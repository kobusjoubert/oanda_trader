require 'rails_helper'

RSpec.describe "user_strategies/edit", type: :view do
  before(:each) do
    @user_strategy = assign(:user_strategy, UserStrategy.create!(
      :user => nil,
      :strategy => nil,
      :config => "MyText"
    ))
  end

  it "renders the edit user_strategy form" do
    render

    assert_select "form[action=?][method=?]", user_strategy_path(@user_strategy), "post" do

      assert_select "input#user_strategy_user_id[name=?]", "user_strategy[user_id]"

      assert_select "input#user_strategy_strategy_id[name=?]", "user_strategy[strategy_id]"

      assert_select "textarea#user_strategy[name=?]", "user_strategy[config]"
    end
  end
end
