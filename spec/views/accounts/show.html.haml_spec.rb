require 'rails_helper'

RSpec.describe "accounts/show", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
      :trade_account_id => "Trade Account",
      :trade_account_alias => "Trade Account Alias",
      :access_token => "Access Token",
      :default => false,
      :practice => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Trade Account/)
    expect(rendered).to match(/Trade Account Alias/)
    expect(rendered).to match(/Access Token/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
