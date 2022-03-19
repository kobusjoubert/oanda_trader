class ChangeActivitiesPricePrecision < ActiveRecord::Migration[5.0]
  def up
    change_column :activities, :price, :decimal, precision: 11, scale: 5
  end

  def down
    change_column :activities, :price, :decimal, precision: 8, scale: 5
  end
end
