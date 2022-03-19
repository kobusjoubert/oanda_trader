class DropCandles < ActiveRecord::Migration[5.0]
  def up
    drop_table :candles if ActiveRecord::Base.connection.table_exists? :candles
  end

  def down
    create_table :candles do |t|
      t.string :instrument
      t.string :granularity
      t.datetime :time
      t.integer :volume
      t.decimal :bid_open, precision: 8, scale: 5
      t.decimal :bid_high, precision: 8, scale: 5
      t.decimal :bid_low, precision: 8, scale: 5
      t.decimal :bid_close, precision: 8, scale: 5
      t.decimal :ask_open, precision: 8, scale: 5
      t.decimal :ask_high, precision: 8, scale: 5
      t.decimal :ask_low, precision: 8, scale: 5
      t.decimal :ask_close, precision: 8, scale: 5
      t.decimal :mid_open, precision: 8, scale: 5
      t.decimal :mid_high, precision: 8, scale: 5
      t.decimal :mid_low, precision: 8, scale: 5
      t.decimal :mid_close, precision: 8, scale: 5

      t.timestamps
    end

    add_index :candles, [:instrument, :granularity, :time], unique: true
  end
end
