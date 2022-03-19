require 'rails_helper'

RSpec.describe "user_strategies/index", type: :view do
  before(:each) do
    assign(:user_strategies, [
      UserStrategy.create!(
        :user => nil,
        :strategy => nil,
        :config => "MyText"
      ),
      UserStrategy.create!(
        :user => nil,
        :strategy => nil,
        :config => "MyText"
      )
    ])
  end

  it "renders a list of user_strategies" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
