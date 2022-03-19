class ActivitiesController < ApplicationController
  before_action :set_user_strategy, only: [:destroy, :delete]

  # GET /user_strategies/:user_strategy_id/activities
  def delete
    respond_to do |format|
      format.js
    end
  end

  # DELETE /user_strategies/:user_strategy_id/activities
  def destroy
    @user_strategy.activities.send(params[:user_strategy][:activities]).destroy_all
    respond_to do |format|
      format.html { redirect_to favourites_strategies_path, notice: t('activities_deleted') }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def set_user_strategy
    @user_strategy = current_user.current_account.user_strategies.find(params[:user_strategy_id])
  end
end
