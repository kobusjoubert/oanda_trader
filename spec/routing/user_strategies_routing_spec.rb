require "rails_helper"

RSpec.describe UserStrategiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_strategies").to route_to("user_strategies#index")
    end

    it "routes to #new" do
      expect(:get => "/user_strategies/new").to route_to("user_strategies#new")
    end

    it "routes to #show" do
      expect(:get => "/user_strategies/1").to route_to("user_strategies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_strategies/1/edit").to route_to("user_strategies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_strategies").to route_to("user_strategies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_strategies/1").to route_to("user_strategies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_strategies/1").to route_to("user_strategies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_strategies/1").to route_to("user_strategies#destroy", :id => "1")
    end

  end
end
