require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

  describe 'associations' do
    it { is_expected.to have_many(:accounts).dependent(:destroy) }
  end

  describe 'validations' do
    it 'is valid with a valid email and password' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      user.save!
      duplicate = User.new(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include('has already been taken')
    end

    it 'is invalid without a password' do
      user.password = nil
      user.password_confirmation = nil
      expect(user).not_to be_valid
    end

    it 'is invalid when password is too short' do
      user.password = 'short'
      user.password_confirmation = 'short'
      expect(user).not_to be_valid
    end

    it 'is invalid with a malformed email' do
      user.email = 'not-an-email'
      expect(user).not_to be_valid
    end
  end

  describe '#to_s' do
    context 'when display_name is set' do
      it 'returns the display_name' do
        user.display_name = 'Kenny McCormick'
        expect(user.to_s).to eq('Kenny McCormick')
      end
    end

    context 'when display_name is nil' do
      it 'returns the email' do
        user.display_name = nil
        expect(user.to_s).to eq('test@example.com')
      end
    end
  end

  describe '#current_account' do
    before { user.save! }

    context 'when the user has no accounts' do
      it 'returns nil' do
        expect(user.current_account).to be_nil
      end
    end

    context 'when the user has a current account' do
      let!(:account) { Account.create!(user: user, trade_account_id: '001-001-111-001', current: true) }

      it 'returns the current account' do
        expect(user.current_account).to eq(account)
      end
    end

    context 'when the user has multiple accounts and only one is current' do
      let!(:non_current) { Account.create!(user: user, trade_account_id: '001-001-111-001', current: false) }
      let!(:current_acc) { Account.create!(user: user, trade_account_id: '001-001-111-002', current: true) }

      it 'returns the current account' do
        expect(user.current_account).to eq(current_acc)
      end

      it 'does not return the non-current account' do
        expect(user.current_account).not_to eq(non_current)
      end
    end
  end
end
