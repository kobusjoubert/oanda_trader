require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

  # Accounts are created without access_token so the initialize method doesn't
  # call OandaApiV20. The before_create callback still publishes to RabbitMQ,
  # which is stubbed globally in spec/support/rabbitmq.rb.
  def build_account(attrs = {})
    Account.new({ user: user, trade_account_id: '001-001-111-001' }.merge(attrs))
  end

  def create_account(attrs = {})
    Account.create!({ user: user, trade_account_id: '001-001-111-001' }.merge(attrs))
  end

  describe 'associations' do
    subject { build_account }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:user_strategies).dependent(:destroy) }
  end

  describe 'persistence' do
    it 'persists with required attributes' do
      expect { create_account }.to change(Account, :count).by(1)
    end

    it 'is valid by default' do
      # Account model has no explicit validates calls; data is populated by
      # the initialize callback from the OandaApiV20 API in production.
      expect(build_account).to be_valid
    end
  end

  describe 'scopes' do
    describe '.current' do
      let!(:current_account)     { create_account(trade_account_id: '001-001-111-001', current: true) }
      let!(:non_current_account) { Account.create!(user: user, trade_account_id: '001-001-111-002', current: false) }

      it 'returns only current accounts' do
        expect(Account.current).to include(current_account)
        expect(Account.current).not_to include(non_current_account)
      end
    end
  end

  describe 'callbacks' do
    describe '#update_current (after_update)' do
      let!(:first)  { Account.create!(user: user, trade_account_id: '001-001-111-001', current: true) }
      let!(:second) { Account.create!(user: user, trade_account_id: '001-001-111-002', current: false) }

      it 'marks all other accounts as non-current when an account is set to current' do
        second.update!(current: true)
        expect(first.reload.current).to be false
        expect(second.reload.current).to be true
      end
    end

    describe '#validate_no_active_strategies (before_destroy)' do
      let!(:account)  { create_account }
      let!(:strategy) { Strategy.create!(name: 'Test', worker_name: 'test_worker_destroy') }
      let!(:user_strategy) do
        UserStrategy.create!(account: account, strategy: strategy, state: :started)
      end

      it 'prevents destruction when active strategies exist' do
        expect { account.destroy }.not_to change(Account, :count)
      end

      it 'adds an error when active strategies prevent deletion' do
        account.destroy
        expect(account.errors[:base]).not_to be_empty
      end

      it 'allows destruction when no active strategies exist' do
        user_strategy.update!(state: :stopped)
        expect { account.destroy }.to change(Account, :count).by(-1)
      end
    end
  end

  describe '#margin_closeout_percent' do
    let(:account) { build_account }

    it 'returns 0.0 when summary is empty' do
      account.summary = {}
      expect(account.margin_closeout_percent).to eq(0.0)
    end

    it 'converts the fraction to a percentage rounded to 2 decimal places' do
      account.summary = { 'marginCloseoutPercent' => '0.1234' }
      expect(account.margin_closeout_percent).to eq(12.34)
    end
  end
end
