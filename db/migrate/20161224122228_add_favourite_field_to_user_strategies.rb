class AddFavouriteFieldToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategies, :favourite, :boolean, default: false
    add_index :user_strategies, :favourite
  end
end
