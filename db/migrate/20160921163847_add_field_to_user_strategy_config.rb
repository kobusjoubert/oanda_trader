class AddFieldToUserStrategyConfig < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategy_configs, :margin, :float
    add_column :user_strategy_configs, :take_profit_at, :integer
    add_column :user_strategy_configs, :stop_loss_at, :integer
    add_column :user_strategy_configs, :cut_off_time, :time
  end
end
