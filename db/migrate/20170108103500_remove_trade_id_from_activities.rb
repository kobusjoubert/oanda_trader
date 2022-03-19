class RemoveTradeIdFromActivities < ActiveRecord::Migration[5.0]
  def change
    remove_reference :activities, :trade, index: true, foriegn_key: true
  end
end
