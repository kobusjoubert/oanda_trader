class RemoveConfigFromUserStrategies < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_strategies, :config, :text
  end
end
