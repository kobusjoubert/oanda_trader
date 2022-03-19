class AddExitFridayAtToStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :strategies, :exit_friday_at, :time
  end
end
