class Account < ApplicationRecord
  belongs_to :user
  has_many :user_strategies, dependent: :destroy

  before_create  :update_attributes
  before_update  :update_attributes
  after_update   :update_current
  before_destroy :validate_no_active_strategies, prepend: true
  before_destroy :delete_attributes

  serialize :summary, Hash

  attr_encrypted :access_token, key: Rails.application.secrets.access_token_key

  scope :current, -> { where(current: true) }

  def initialize(options = {})
    super

    if options[:access_token].present?
      practice   = options[:practice].to_i == 1 ? true : false
      client     = Rails.env.backtest? ? OandaApiV20Backtest.new : OandaApiV20.new(access_token: options[:access_token], practice: practice)
      account_id = (options[:trade_account_id] || client.accounts.show['accounts'].first['id']).strip
      account    = client.account(account_id).summary.show

      if account['account']
        self.trade_account_id = account['account']['id']
        self.alias            = account['account']['alias']
        self.balance          = account['account']['balance']
        self.summary          = account['account']
      end
    end
  end

  def oanda_client
    @oanda_client ||= Rails.env.backtest? ? OandaApiV20Backtest.new : OandaApiV20.new(access_token: access_token, practice: practice)
  end

  def refresh_attributes
    account = oanda_client.account(trade_account_id).summary.show

    if account['account']
      self.alias   = account['account']['alias']
      self.balance = account['account']['balance']
      self.summary = account['account']
    end

    save
  end

  def margin_closeout_percent
    (summary['marginCloseoutPercent'].to_f * 100).round(2)
  end

  private

  def update_attributes
    if alias_changed?
      options = { alias: self.alias }
      oanda_client.account(trade_account_id).configuration(options).update
    end

    data = { action: 'update_redis_keys', practice: practice, account: trade_account_id, max_concurrent_trades: max_concurrent_trades }
    data.merge!(access_token: access_token) if access_token_changed? || encrypted_access_token_changed?

    $rabbitmq_exchange.publish(data.to_json, routing_key: 'qw_account_update')
  end

  def delete_attributes
    data = { action: 'delete_redis_keys', practice: practice, account: trade_account_id, access_token: access_token }
    $rabbitmq_exchange.publish(data.to_json, routing_key: 'qw_account_update')
  end

  def update_current
    if current
      accounts = Account.where(user_id: user_id).where.not(id: id)
      accounts.update_all(current: false)
    end
  end

  def validate_no_active_strategies
    if user_strategies.active.any?
      self.errors.add(:base, I18n.t('messages.account_not_deleted_check_strategies'))
      throw(:abort)
    end
  end
end
