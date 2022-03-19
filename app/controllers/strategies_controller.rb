class StrategiesController < ApplicationController
  before_action :ensure_current_account, only: [:index, :favourites]

  # GET /strategies
  def index
    @strategies = Strategy.all.order(worker_name: :asc)
  end

  # GET /strategies/favourites
  def favourites
    # @strategies = current_user.current_account.user_strategies.favourite
    @strategies = Strategy.joins(:user_strategies).where('user_strategies.account_id = :account_id AND user_strategies.favourite = TRUE', account_id: current_user.current_account.id).order(worker_name: :asc)
  end

  private

  def ensure_current_account
    redirect_to accounts_path, notice: t('messages.set_account_to_trade_with') unless current_user.current_account
  end
end
