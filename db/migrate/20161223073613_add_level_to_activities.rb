class AddLevelToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :level, :integer, default: 0
  end
end
