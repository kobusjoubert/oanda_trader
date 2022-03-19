class AddTakeProfitAndStopLossToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :take_profit, :decimal, precision: 8, scale: 5
    add_column :activities, :stop_loss, :decimal, precision: 8, scale: 5
  end
end
