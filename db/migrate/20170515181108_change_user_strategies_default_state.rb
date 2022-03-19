class ChangeUserStrategiesDefaultState < ActiveRecord::Migration[5.0]
  def up
    change_column_default :user_strategies, :state, 0
  end

  def down
    change_column_default :user_strategies, :state, 1
  end
end
