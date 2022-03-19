class AddUnitsToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategies, :units, :integer
  end
end
