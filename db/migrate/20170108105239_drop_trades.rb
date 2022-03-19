class DropTrades < ActiveRecord::Migration[5.0]
  def change
    drop_table :trades
  end
end
