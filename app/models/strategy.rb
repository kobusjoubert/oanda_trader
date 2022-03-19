class Strategy < ApplicationRecord
  has_many :user_strategies, dependent: :destroy

  serialize :default_config, Hash

  def trading_hours
    "#{trade_from.try(:to_s, :time)} - #{trade_to.try(:to_s, :time)}"
  end

  def market_hours
    "#{market_open_at.try(:to_s, :time)} - #{market_close_at.try(:to_s, :time)}"
  end
end
