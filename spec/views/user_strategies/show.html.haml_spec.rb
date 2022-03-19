require 'rails_helper'

RSpec.describe "user_strategies/show", type: :view do
  before(:each) do
    @user_strategy = assign(:user_strategy, UserStrategy.create!(
      :user => nil,
      :strategy => nil,
      :config => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
