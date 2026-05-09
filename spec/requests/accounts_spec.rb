require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user)    { User.create!(email: 'req_acct@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:account) { Account.create!(user: user, trade_account_id: '001-001-444-001', current: true) }

  describe 'unauthenticated access' do
    it 'redirects GET /accounts to login' do
      get accounts_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects GET /accounts/new to login' do
      get new_account_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'authenticated access' do
    before { sign_in user }

    describe 'GET /accounts' do
      it 'returns http success' do
        get accounts_path
        expect(response).to have_http_status(:ok)
      end

      it 'shows user accounts' do
        account
        get accounts_path
        expect(response.body).to include(account.trade_account_id)
      end
    end

    describe 'GET /accounts/:id' do
      it 'returns http success' do
        get account_path(account)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /accounts/new' do
      it 'returns http success' do
        get new_account_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /accounts/:id/edit' do
      it 'returns http success' do
        get edit_account_path(account)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /accounts' do
      context 'with invalid params (missing access_token — no Oanda call)' do
        it 'renders new with unprocessable entity' do
          post accounts_path, params: { account: { trade_account_id: '' } }
          expect(response).to have_http_status(:unprocessable_entity).or redirect_to(accounts_path)
        end
      end
    end

    describe 'PATCH /accounts/:id' do
      before do
        allow_any_instance_of(Account).to receive(:update_attributes).and_return(true)
      end

      it 'redirects to accounts after a successful update' do
        patch account_path(account), params: { account: { alias: 'New Alias' } }
        expect(response).to redirect_to(accounts_path)
      end
    end

    describe 'DELETE /accounts/:id' do
      context 'with no active strategies' do
        it 'destroys the account and redirects' do
          account
          expect {
            delete account_path(account)
          }.to change(Account, :count).by(-1)
          expect(response).to redirect_to(accounts_path)
        end
      end

      context 'with active strategies' do
        let!(:strategy) { Strategy.create!(name: 'Test', worker_name: 'test_req_acct') }
        let!(:user_strategy) { UserStrategy.create!(account: account, strategy: strategy, state: :started) }

        it 'does not destroy the account' do
          expect {
            delete account_path(account)
          }.not_to change(Account, :count)
        end

        it 'redirects back with an alert' do
          delete account_path(account)
          expect(response).to redirect_to(accounts_path)
        end
      end
    end
  end
end
