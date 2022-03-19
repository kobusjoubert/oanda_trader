class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /accounts
  def index
    @accounts = current_user.accounts.order(:id)
  end

  # GET /accounts/:id
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/:id/edit
  def edit
  end

  # POST /accounts
  def create
    @account = current_user.accounts.new(account_params_on_create)
    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, notice: "#{t('messages.account_successfully_created')} #{t('messages.set_account_to_trade_with')}" }
        format.json { render :show, status: :created, location: @account }
      else
        format.html do
          # @account.errors.full_messages.each { |msg| flash[:error] = msg }
          render :new
        end
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/:id
  def update
    respond_to do |format|
      if @account.update(account_params_on_update)
        format.js   { redirect_to accounts_path }
        format.html { redirect_to accounts_path }
        # format.json { render :show, status: :ok, location: @account }
      else
        format.js   { redirect_to accounts_path, alert: t('messages.account_not_updated') }
        format.html { redirect_to accounts_path, alert: t('messages.account_not_updated') }
        # format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/:id
  def destroy
    respond_to do |format|
      if @account.destroy
        format.html { redirect_to accounts_path, notice: t('messages.account_successfully_destroyed') }
      else
        format.html { redirect_to accounts_path, alert: @account.errors.full_messages.join("\n") }
      end
    end
  end

  # PATCH/PUT /accounts/:id/refresh
  def refresh
    respond_to do |format|
      if @account.refresh_attributes
        format.html { redirect_to accounts_path }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { redirect_to accounts_path, alert: t('messages.account_not_updated') }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/refresh_current
  def refresh_current
    respond_to do |format|
      current_user.current_account.refresh_attributes
      format.js
    end
  end

  private

  def account_params_on_create
    params.require(:account).permit(:trade_account_id, :access_token, :practice, :max_concurrent_trades)
  end

  def account_params_on_update
    params[:account].delete(:access_token) if params[:account][:access_token].blank?
    params.require(:account).permit(:access_token, :current, :alias, :max_concurrent_trades)
  end

  def account_params_on_refresh
    params.require(:accounts)
  end

  def set_account
    @account = current_user.accounts.find(params[:id])
  end
end
