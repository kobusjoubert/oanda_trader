class CreateInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :instruments do |t|
      t.string :name
      t.string :ticker
      t.string :description
      t.string :type
      t.string :session
      t.string :exchange
      t.string :listed_exchange
      t.float :min_movement
      t.float :min_movement_2
      t.integer :price_scale
      t.boolean :fractional

      t.timestamps
    end
  end
end
