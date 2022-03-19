class AddStateToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategies, :state, :integer, default: 1
  end
end
