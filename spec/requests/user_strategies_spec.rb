require 'rails_helper'

RSpec.describe "UserStrategies", type: :request do
  describe "GET /user_strategies" do
    it "works! (now write some real specs)" do
      get user_strategies_path
      expect(response).to have_http_status(200)
    end
  end
end
