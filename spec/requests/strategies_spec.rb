require 'rails_helper'

RSpec.describe "Strategies", type: :request do
  let(:user)     { User.create!(email: 'strat_req@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account)  { Account.create!(user: user, trade_account_id: '001-001-777-001', current: true) }
  let!(:strategy) do
    Strategy.create!(name: 'EUR/USD Strat', worker_name: 'eurusd_strat_req_spec', instrument: 'EUR_USD')
  end

  describe 'unauthenticated access' do
    it 'redirects GET /strategies to login' do
      get strategies_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects GET /strategies/favourites to login' do
      get favourites_strategies_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'authenticated access' do
    before { sign_in user }

    context 'when the user has no current account' do
      it 'redirects GET /strategies to accounts page' do
        get strategies_path
        expect(response).to redirect_to(accounts_path)
      end

      it 'redirects GET /strategies/favourites to accounts page' do
        get favourites_strategies_path
        expect(response).to redirect_to(accounts_path)
      end
    end

    context 'when the user has a current account' do
      before { account }

      describe 'GET /strategies' do
        it 'returns http success' do
          get strategies_path
          expect(response).to have_http_status(:ok)
        end

        it 'lists all strategies' do
          get strategies_path
          expect(response.body).to include(strategy.name)
        end
      end

      describe 'GET /strategies/favourites' do
        it 'returns http success' do
          get favourites_strategies_path
          expect(response).to have_http_status(:ok)
        end

        it 'only shows favourite user_strategies' do
          UserStrategy.create!(account: account, strategy: strategy, favourite: true)
          get favourites_strategies_path
          expect(response.body).to include(strategy.name)
        end
      end
    end
  end
end
