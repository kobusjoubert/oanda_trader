require 'rails_helper'

RSpec.describe StrategyActivityJob, type: :job do
  let(:user)     { User.create!(email: 'job@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account)  { Account.create!(user: user, trade_account_id: '001-001-666-001', practice: false) }
  let(:strategy) { Strategy.create!(name: 'EUR Job', worker_name: 'eurusd_job_spec', instrument: 'EUR_USD') }
  let!(:user_strategy) { UserStrategy.create!(account: account, strategy: strategy, state: :started) }

  let(:valid_message) do
    {
      account:       '001-001-666-001',
      strategy:      'eurusd_job_spec',
      practice:      false,
      level:         'info',
      message:       'Trade opened',
      published_at:  Time.current.to_s
    }.to_json
  end

  before do
    allow(ActionCable.server).to receive(:broadcast)
  end

  subject(:job) { described_class.new }

  describe '#work' do
    context 'with a valid message' do
      it 'creates an Activity record' do
        expect { job.work(valid_message) }.to change(Activity, :count).by(1)
      end

      it 'acks the message' do
        expect(job).to receive(:ack!)
        job.work(valid_message)
      end

      it 'broadcasts to the user activity channel' do
        job.work(valid_message)
        expect(ActionCable.server).to have_received(:broadcast)
          .with("user_#{user.id}_activities", anything)
      end

      it 'stores the comment from the message field' do
        job.work(valid_message)
        expect(Activity.last.comment).to eq('Trade opened')
      end
    end

    context 'with a message missing required fields' do
      let(:invalid_message) { { account: '001-001-666-001' }.to_json }

      it 'raises an ArgumentError' do
        expect { job.work(invalid_message) }.to raise_error(ArgumentError)
      end
    end

    context 'when the account does not exist' do
      let(:bad_account_msg) do
        { account: 'NONEXISTENT', strategy: 'eurusd_job_spec', practice: false }.to_json
      end

      it 'requeues the message on ActiveRecord errors' do
        expect(job).to receive(:requeue!)
        job.work(bad_account_msg)
      end
    end
  end
end
