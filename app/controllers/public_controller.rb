class PublicController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /public/home
  def home
  end
end
