require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        :trade_account_id => "Trade Account",
        :trade_account_alias => "Trade Account Alias",
        :access_token => "Access Token",
        :default => false,
        :practice => false
      ),
      Account.create!(
        :trade_account_id => "Trade Account",
        :trade_account_alias => "Trade Account Alias",
        :access_token => "Access Token",
        :default => false,
        :practice => false
      )
    ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", :text => "Trade Account".to_s, :count => 2
    assert_select "tr>td", :text => "Trade Account Alias".to_s, :count => 2
    assert_select "tr>td", :text => "Access Token".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
