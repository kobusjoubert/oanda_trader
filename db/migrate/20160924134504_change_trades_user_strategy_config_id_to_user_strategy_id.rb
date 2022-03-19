class ChangeTradesUserStrategyConfigIdToUserStrategyId < ActiveRecord::Migration[5.0]
  def change
    change_table :trades do |t|
      t.rename :user_strategy_config_id, :user_strategy_id
    end
  end
end
