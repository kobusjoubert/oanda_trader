class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :trade_account_id, null: false
      t.string :alias
      t.string :balance
      t.string :encrypted_access_token
      t.string :encrypted_access_token_iv
      t.boolean :practice, default: false
      t.boolean :current, default: false

      t.timestamps
    end

    add_index :accounts, [:trade_account_id, :practice], unique: true
  end
end
