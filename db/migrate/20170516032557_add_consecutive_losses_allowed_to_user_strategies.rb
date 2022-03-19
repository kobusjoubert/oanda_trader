class AddConsecutiveLossesAllowedToUserStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :user_strategies, :consecutive_losses_allowed, :integer
  end
end
