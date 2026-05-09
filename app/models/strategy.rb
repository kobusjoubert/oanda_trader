class Strategy < ApplicationRecord
  has_many :user_strategies, dependent: :destroy

  serialize :default_config, Hash

  def trading_hours
    "#{trade_from.try(:to_fs, :time)} - #{trade_to.try(:to_fs, :time)}"
  end

  def market_hours
    "#{market_open_at.try(:to_fs, :time)} - #{market_close_at.try(:to_fs, :time)}"
  end
end
