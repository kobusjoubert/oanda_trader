class AddUserStrategyIdToActivities < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :user_strategy, index: true, foriegn_key: true
    add_foreign_key :activities, :user_strategies, on_delete: :cascade
  end
end
