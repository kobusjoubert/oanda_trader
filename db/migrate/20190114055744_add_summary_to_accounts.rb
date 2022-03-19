class AddSummaryToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :summary, :text
  end
end
