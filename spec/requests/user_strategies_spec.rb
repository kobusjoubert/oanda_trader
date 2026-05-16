require 'rails_helper'

RSpec.describe "UserStrategies", type: :request do
  let(:user) { User.create!(email: 'us_req@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account) { Account.create!(user: user, trade_account_id: '001-001-555-001', current: true) }
  let(:strategy) do
    Strategy.create!(
      name:        'EUR/USD Test',
      worker_name: 'eurusd_req_spec',
      instrument:  'EUR_USD'
    )
  end
  let(:user_strategy) { UserStrategy.create!(account: account, strategy: strategy) }

  describe 'unauthenticated access' do
    it 'redirects POST /user_strategies to login' do
      post user_strategies_path, params: { user_strategy: { strategy_id: strategy.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'authenticated access' do
    before { sign_in user }

    describe 'GET /strategies/:strategy_id/user_strategies/new' do
      it 'returns http success' do
        get new_strategy_user_strategy_path(strategy)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /strategies/:strategy_id/user_strategies/:id' do
      it 'returns http success' do
        get strategy_user_strategy_path(strategy, user_strategy)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /strategies/:strategy_id/user_strategies/:id/edit' do
      it 'returns http success' do
        get edit_strategy_user_strategy_path(strategy, user_strategy)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /user_strategies' do
      before { account } # ensure user has a current_account before POST

      it 'creates a new user_strategy and redirects to favourites' do
        expect {
          post user_strategies_path, params: {
            user_strategy: { strategy_id: strategy.id }
          }
        }.to change(UserStrategy, :count).by(1)
        expect(response).to redirect_to(favourites_strategies_path)
      end
    end

    describe 'PATCH /user_strategies/:id' do
      before do
        allow(StrategyPublish).to receive(:publish_to_worker)
      end

      it 'updates the user_strategy and redirects to favourites' do
        patch user_strategy_path(user_strategy), params: {
          user_strategy: { units: 200 }
        }
        expect(response).to redirect_to(favourites_strategies_path)
        expect(user_strategy.reload.units).to eq(200)
      end
    end
  end
end
