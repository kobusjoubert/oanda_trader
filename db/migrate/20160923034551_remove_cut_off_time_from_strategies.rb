class RemoveCutOffTimeFromStrategies < ActiveRecord::Migration[5.0]
  def change
    remove_column :strategies, :cut_off_time, :time
  end
end
