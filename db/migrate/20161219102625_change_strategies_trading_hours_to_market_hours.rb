class ChangeStrategiesTradingHoursToMarketHours < ActiveRecord::Migration[5.0]
  def change
    change_table :strategies do |t|
      t.rename :trade_from, :market_open_at
      t.rename :trade_to, :market_close_at
    end
  end
end
