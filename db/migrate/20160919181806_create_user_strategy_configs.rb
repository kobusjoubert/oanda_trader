class CreateUserStrategyConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :user_strategy_configs do |t|
      t.references :account, foreign_key: true
      t.references :strategy, foreign_key: true
      t.text :config

      t.timestamps
    end
  end
end
