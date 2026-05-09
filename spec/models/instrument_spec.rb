require 'rails_helper'

RSpec.describe Instrument, type: :model do
  subject(:instrument) do
    Instrument.new(
      name:        'EUR/USD',
      ticker:      'EURUSD_spec',
      description: 'Euro vs US Dollar',
      type:        'CURRENCY',
      min_movement: 0.00001,
      price_scale:  5
    )
  end

  it 'is valid with all attributes' do
    expect(instrument).to be_valid
  end

  it 'persists to the database' do
    instrument.save!
    expect(Instrument.find_by(ticker: 'EURUSD_spec')).to eq(instrument)
  end

  it 'stores the type column without STI conflict' do
    # Instrument uses self.inheritance_column = nil to disable STI on the type column
    instrument.save!
    reloaded = Instrument.find(instrument.id)
    expect(reloaded.type).to eq('CURRENCY')
  end

  it 'stores min_movement as a float' do
    instrument.save!
    expect(instrument.reload.min_movement).to be_within(0.000001).of(0.00001)
  end
end
