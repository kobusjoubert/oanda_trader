class RemoveIndexOnAccounts < ActiveRecord::Migration[5.0]
  def up
    remove_index :accounts, [:trade_account_id, :practice]
  end

  def down
    add_index :accounts, [:trade_account_id, :practice], unique: true
  end
end
