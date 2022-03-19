class AddStateToTrades < ActiveRecord::Migration[5.0]
  def change
    add_column :trades, :state, :integer, default: 1
  end
end
