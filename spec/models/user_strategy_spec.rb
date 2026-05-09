require 'rails_helper'

RSpec.describe UserStrategy, type: :model do
  let(:user)     { User.create!(email: 'trader@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account)  { Account.create!(user: user, trade_account_id: '001-001-222-001', current: true) }
  let(:strategy) do
    Strategy.create!(
      name:            'GBP/USD Trend',
      worker_name:     'gbpusd_trend_us_spec',
      instrument:      'GBP_USD',
      market_open_at:  Time.parse('08:00:00'),
      market_close_at: Time.parse('20:00:00'),
      trade_from:      Time.parse('09:00:00'),
      trade_to:        Time.parse('17:00:00'),
      default_config:  {
        take_profit_at:             50,
        stop_loss_at:               30,
        chart_interval:             3600,
        units:                      100,
        consecutive_losses_allowed: 3
      }
    )
  end

  subject(:user_strategy) { UserStrategy.new(account: account, strategy: strategy) }

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:strategy) }
    it { is_expected.to have_many(:activities).dependent(:destroy) }
  end

  describe 'delegation to strategy' do
    before { user_strategy.save! }

    it 'delegates name to strategy'        do expect(user_strategy.name).to eq(strategy.name) end
    it 'delegates worker_name to strategy' do expect(user_strategy.worker_name).to eq(strategy.worker_name) end
    it 'delegates instrument to strategy'  do expect(user_strategy.instrument).to eq('GBP_USD') end
    it 'delegates trading_hours'           do expect(user_strategy.trading_hours).to eq(strategy.trading_hours) end
    it 'delegates market_hours'            do expect(user_strategy.market_hours).to eq(strategy.market_hours) end
  end

  describe 'enums' do
    it 'defines state enum with stopped as 0 (default)' do
      expect(UserStrategy.states[:stopped]).to eq(0)
      expect(UserStrategy.states[:started]).to eq(1)
      expect(UserStrategy.states[:paused]).to eq(2)
      expect(UserStrategy.states[:halted]).to eq(3)
      expect(UserStrategy.states[:temporary_halted]).to eq(4)
    end

    it 'defaults state to stopped' do
      user_strategy.save!
      expect(user_strategy.state).to eq('stopped')
    end
  end

  describe 'scopes' do
    let!(:fav)     { UserStrategy.create!(account: account, strategy: strategy, favourite: true) }
    let!(:non_fav) do
      s2 = Strategy.create!(name: 'Other', worker_name: 'other_us_spec')
      UserStrategy.create!(account: account, strategy: s2, favourite: false)
    end
    let!(:active_us) do
      s3 = Strategy.create!(name: 'Active', worker_name: 'active_us_spec')
      UserStrategy.create!(account: account, strategy: s3, state: :started)
    end
    let!(:stopped_us) do
      s4 = Strategy.create!(name: 'Stopped', worker_name: 'stopped_us_spec')
      UserStrategy.create!(account: account, strategy: s4, state: :stopped)
    end

    describe '.favourite' do
      it 'includes favourited user strategies' do
        expect(UserStrategy.favourite).to include(fav)
      end

      it 'excludes non-favourited user strategies' do
        expect(UserStrategy.favourite).not_to include(non_fav)
      end
    end

    describe '.active' do
      it 'includes non-stopped user strategies' do
        expect(UserStrategy.active).to include(active_us)
      end

      it 'excludes stopped user strategies' do
        expect(UserStrategy.active).not_to include(stopped_us)
      end
    end
  end

  describe 'attribute accessors falling back to default_config' do
    before { user_strategy.save! }

    context 'when user_strategy values are nil' do
      it '#take_profit_at falls back to default_config' do
        expect(user_strategy.take_profit_at).to eq(50)
      end

      it '#stop_loss_at falls back to default_config' do
        expect(user_strategy.stop_loss_at).to eq(30)
      end

      it '#chart_interval falls back to default_config' do
        expect(user_strategy.chart_interval).to eq(3600)
      end

      it '#units falls back to default_config' do
        expect(user_strategy.units).to eq(100)
      end

      it '#consecutive_losses_allowed falls back to default_config' do
        expect(user_strategy.consecutive_losses_allowed).to eq(3)
      end
    end

    context 'when user_strategy values are set' do
      before { user_strategy.update!(take_profit_at: 75, stop_loss_at: 25, units: 200) }

      it '#take_profit_at uses the user_strategy value' do
        expect(user_strategy.take_profit_at).to eq(75)
      end

      it '#stop_loss_at uses the user_strategy value' do
        expect(user_strategy.stop_loss_at).to eq(25)
      end

      it '#units uses the user_strategy value' do
        expect(user_strategy.units).to eq(200)
      end
    end
  end

  describe '#instrument_already_trading?' do
    let!(:saved_us) { UserStrategy.create!(account: account, strategy: strategy, state: :stopped) }
    let!(:strategy2) do
      Strategy.create!(name: 'GBP/USD Alt', worker_name: 'gbpusd_alt_us_spec', instrument: 'GBP_USD')
    end
    let!(:new_us) { UserStrategy.new(account: account, strategy: strategy2) }

    context 'when no started strategy trades the same instrument' do
      it 'returns false' do
        expect(new_us.instrument_already_trading?).to be false
      end
    end

    context 'when a started strategy already trades the same instrument' do
      before { saved_us.update!(state: :started) }

      it 'returns true' do
        expect(new_us.instrument_already_trading?).to be true
      end
    end
  end
end
