class AddIndexOnAccounts < ActiveRecord::Migration[5.0]
  def up
    add_index :accounts, :trade_account_id, unique: true
  end

  def down
    remove_index :accounts, :trade_account_id
  end
end
