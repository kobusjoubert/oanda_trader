require 'rails_helper'

RSpec.describe "Public", type: :request do
  describe 'GET /' do
    it 'returns http success without authentication' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /public/home' do
    it 'returns http success without authentication' do
      get public_home_path
      expect(response).to have_http_status(:ok)
    end
  end
end
