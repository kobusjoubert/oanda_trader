class AddFieldsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :position, :integer
    add_column :activities, :action, :integer
    add_column :activities, :units, :integer
    add_column :activities, :price, :decimal, precision: 8, scale: 5
    add_column :activities, :transaction_id, :integer
    add_index :activities, [:action, :position]
    add_index :activities, :position
  end
end
