class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.references :trade, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
