class CreateStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :strategies do |t|
      t.string :name, null: false
      t.string :worker_name, null: false
      t.text :description
      t.time :trade_from
      t.time :trade_to
      t.time :cut_off_time
      t.text :default_config

      t.timestamps
    end

    add_index :strategies, :worker_name, unique: true
  end
end
