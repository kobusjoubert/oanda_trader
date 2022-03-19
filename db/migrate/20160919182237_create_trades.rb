class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.references :user_strategy_config, foreign_key: true
      t.datetime :ended_at

      t.timestamps
    end
  end
end
