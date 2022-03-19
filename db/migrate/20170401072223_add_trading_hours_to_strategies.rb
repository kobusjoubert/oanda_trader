class AddTradingHoursToStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :strategies, :trade_from, :time
    add_column :strategies, :trade_to, :time
  end
end
