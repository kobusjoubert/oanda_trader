class UserStrategiesController < ApplicationController
  before_action :set_user_strategy, only: [:show, :edit, :update, :destroy]
  before_action :set_strategy, only: [:show, :new]
  before_action :set_activities, only: [:show]

  # # GET /user_strategies
  # def index
  #   @user_strategies = UserStrategy.all
  # end

  # GET /strategies/:strategy_id/user_strategies/:id
  def show
  end

  # GET /strategies/:strategy_id/user_strategies/new
  def new
    flash[:warning] = t('messages.set_strategy_config_to_trade_with')
    @user_strategy = UserStrategy.new(strategy: @strategy)
  end

  # GET /strategies/:strategy_id/user_strategies/:id/edit
  def edit
  end

  # POST /user_strategies
  def create
    @user_strategy = current_user.current_account.user_strategies.new(user_strategy_params)
    respond_to do |format|
      if @user_strategy.save
        format.html { redirect_to favourites_strategies_path, notice: t('messages.config_updated') }
      else
        format.html { render :new }
      end
    end
  end

  # NOTE: See link below for $.rails.disableFormElement used in update.js.erb
  # https://github.com/rails/jquery-ujs/blob/master/src/rails.js??
  #
  # PATCH/PUT /user_strategies/:id
  def update
    respond_to do |format|
      format.js   { render 'update', locals: { id: @user_strategy.id, trigger: params[:user_strategy][:trigger] } }
      format.html {
        if @user_strategy.update(user_strategy_params)
          StrategyPublish.publish_to_worker(@user_strategy, @user_strategy.state)
          redirect_to favourites_strategies_path, notice: t('messages.config_updated')
        else
          render :edit
        end
      }
    end
  end

  # # DELETE /user_strategies/:id
  # def destroy
  #   @user_strategy.destroy
  #   respond_to do |format|
  #     format.html { redirect_to user_strategies_url, notice: 'User strategy config was successfully destroyed.' }
  #     format.json { head :no_content }
  #     format.js   { head :ok }
  #   end
  # end

  private

  def user_strategy_params
    params.require(:user_strategy).permit(:user_id, :strategy_id, :trigger, :favourite, :config, :margin, :take_profit_at, :stop_loss_at, :cut_off_time, :chart_interval, :units, :consecutive_losses_allowed)
  end

  def set_user_strategy
    @user_strategy = current_user.current_account.user_strategies.find(params[:id])
  end

  def set_strategy
    @strategy = Strategy.find(params[:strategy_id])
  end

  def set_activities
    @activities = @user_strategy.activities.order(id: :desc).page(params[:page]).per(params[:per_page])
  end
end
