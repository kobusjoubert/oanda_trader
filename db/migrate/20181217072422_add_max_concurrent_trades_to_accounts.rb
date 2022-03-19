class AddMaxConcurrentTradesToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :max_concurrent_trades, :integer, null: false, default: 1
  end
end
