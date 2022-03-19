class AddProfitLossToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :profit_loss, :decimal, precision: 14, scale: 4
  end
end
