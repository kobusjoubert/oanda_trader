class ChangeActivitiesTakeProfitAndStopLossPrecision < ActiveRecord::Migration[5.1]
  def up
    change_column :activities, :take_profit, :decimal, precision: 11, scale: 5
    change_column :activities, :stop_loss, :decimal, precision: 11, scale: 5
  end

  def down
    change_column :activities, :take_profit, :decimal, precision: 8, scale: 5
    change_column :activities, :stop_loss, :decimal, precision: 8, scale: 5
  end
end
