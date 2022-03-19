class AddChartIntervalToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategies, :chart_interval, :integer
  end
end
