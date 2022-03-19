require 'rails_helper'

RSpec.describe "accounts/edit", type: :view do
  before(:each) do
    @account = assign(:account, Account.create!(
      :trade_account_id => "MyString",
      :trade_account_alias => "MyString",
      :access_token => "MyString",
      :default => false,
      :practice => false
    ))
  end

  it "renders the edit account form" do
    render

    assert_select "form[action=?][method=?]", account_path(@account), "post" do

      assert_select "input#account_trade_account_id[name=?]", "account[trade_account_id]"

      assert_select "input#account_trade_account_alias[name=?]", "account[trade_account_alias]"

      assert_select "input#account_access_token[name=?]", "account[access_token]"

      assert_select "input#account_default[name=?]", "account[default]"

      assert_select "input#account_practice[name=?]", "account[practice]"
    end
  end
end
