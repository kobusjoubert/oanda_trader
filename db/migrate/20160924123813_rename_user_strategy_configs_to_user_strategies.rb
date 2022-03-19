class RenameUserStrategyConfigsToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    rename_table :user_strategy_configs, :user_strategies
  end
end
