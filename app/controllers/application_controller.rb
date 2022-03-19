class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::StatementInvalid do |e|
    flash[:error] = e
    redirect_back(fallback_location: root_path)
  end

  rescue_from OandaApiV20::RequestError do |e|
    flash[:error] = e
    redirect_back(fallback_location: root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name])
  end

  private

  def after_sign_in_path_for(current_user)
    unless current_user.accounts.present?
      flash[:notice] = t('messages.add_account')
      return accounts_path
    end

    unless current_user.current_account.present?
      flash[:notice] = t('messages.set_account_to_trade_with')
      return accounts_path
    end

    favourites_strategies_path
  end
end
