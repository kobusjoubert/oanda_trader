require 'rails_helper'

RSpec.describe Strategy, type: :model do
  subject(:strategy) do
    Strategy.new(
      name:            'EUR/USD Scalper',
      worker_name:     'eurusd_scalper_test',
      instrument:      'EUR_USD',
      market_open_at:  Time.parse('09:00:00'),
      market_close_at: Time.parse('17:00:00'),
      trade_from:      Time.parse('10:00:00'),
      trade_to:        Time.parse('16:00:00')
    )
  end

  describe 'associations' do
    it { is_expected.to have_many(:user_strategies).dependent(:destroy) }
  end

  describe 'persistence' do
    it 'is valid with required attributes' do
      expect(strategy).to be_valid
    end

    it 'persists to the database' do
      expect { strategy.save! }.to change(Strategy, :count).by(1)
    end
  end

  describe '#trading_hours' do
    it 'returns trade_from - trade_to formatted as time strings' do
      result = strategy.trading_hours
      expect(result).to include('10:00')
      expect(result).to include('16:00')
    end

    it 'handles nil trade times gracefully' do
      strategy.trade_from = nil
      strategy.trade_to   = nil
      expect { strategy.trading_hours }.not_to raise_error
    end
  end

  describe '#market_hours' do
    it 'returns market_open_at - market_close_at formatted as time strings' do
      result = strategy.market_hours
      expect(result).to include('09:00')
      expect(result).to include('17:00')
    end

    it 'handles nil market times gracefully' do
      strategy.market_open_at  = nil
      strategy.market_close_at = nil
      expect { strategy.market_hours }.not_to raise_error
    end
  end
end
