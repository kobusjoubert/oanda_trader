class AddInstrumentToStrategies < ActiveRecord::Migration[5.0]
  def change
    add_column :strategies, :instrument, :string
  end
end
