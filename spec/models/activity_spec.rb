require 'rails_helper'

RSpec.describe Activity, type: :model do
  let(:user)          { User.create!(email: 'trader@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account)       { Account.create!(user: user, trade_account_id: '001-001-333-001') }
  let(:strategy)      { Strategy.create!(name: 'Test', worker_name: 'test_activity_spec') }
  let(:user_strategy) { UserStrategy.create!(account: account, strategy: strategy) }

  subject(:activity) { Activity.new(user_strategy: user_strategy) }

  describe 'associations' do
    it { is_expected.to belong_to(:user_strategy) }
  end

  describe 'enums' do
    describe 'level' do
      it 'maps default to 0' do
        expect(Activity.levels[:default]).to eq(0)
      end

      it { is_expected.to define_enum_for(:level).with_values(default: 0, success: 1, info: 2, warning: 3, danger: 4, primary: 5, secondary: 6, light: 7, dark: 8) }
    end

    describe 'position' do
      # NOTE: shoulda-matchers' define_enum_for can't be used here because the
      # `scope :positions` on Activity overrides the class method that
      # `enum position:` would normally generate. We assert the mapping directly.
      it 'maps long to 0' do
        expect(Activity.send(:defined_enums)['position']['long']).to eq(0)
      end

      it 'maps short to 1' do
        expect(Activity.send(:defined_enums)['position']['short']).to eq(1)
      end
    end

    describe 'action' do
      it { is_expected.to define_enum_for(:action).with_values(filled: 0, closed: 1, created: 2, cancelled: 3, opened: 4, triggered: 5, reduced: 6) }
    end
  end

  describe 'scopes' do
    let!(:position_activity) do
      Activity.create!(user_strategy: user_strategy, position: :long, action: :opened)
    end
    let!(:default_activity) do
      Activity.create!(user_strategy: user_strategy, level: :default)
    end
    let!(:color_activity) do
      Activity.create!(user_strategy: user_strategy, level: :success)
    end
    let!(:no_position_activity) do
      Activity.create!(user_strategy: user_strategy, level: :info)
    end

    describe '.positions' do
      it 'includes activities with a position set' do
        expect(Activity.positions).to include(position_activity)
      end

      it 'excludes activities without a position' do
        expect(Activity.positions).not_to include(no_position_activity)
      end
    end

    describe '.default' do
      it 'includes activities with level 0 (default)' do
        expect(Activity.default).to include(default_activity)
      end

      it 'excludes activities with higher level values' do
        expect(Activity.default).not_to include(color_activity)
      end
    end

    describe '.color' do
      it 'includes activities with level > 0' do
        expect(Activity.color).to include(color_activity)
      end

      it 'excludes default-level activities' do
        expect(Activity.color).not_to include(default_activity)
      end
    end
  end

  describe 'persistence' do
    it 'saves with all optional fields nil' do
      expect { activity.save! }.not_to raise_error
    end

    it 'saves financial data with correct precision' do
      activity.price       = 1.23456
      activity.take_profit = 1.24000
      activity.stop_loss   = 1.22000
      activity.profit_loss = 12.3456
      activity.save!
      reloaded = activity.reload
      expect(reloaded.price).to eq(1.23456)
      expect(reloaded.profit_loss).to eq(12.3456)
    end
  end
end
