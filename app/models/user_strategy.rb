class UserStrategy < ApplicationRecord
  belongs_to :account
  belongs_to :strategy
  has_many :activities, dependent: :destroy

  delegate :name, :worker_name, :instrument, :description, :market_open_at, :market_close_at, :trade_from, :trade_to, 
           :exit_friday_at, :default_config, :trading_hours, :market_hours,
           to: :strategy

  enum state: [:stopped, :started, :paused, :halted, :temporary_halted]

  serialize :config, Hash

  scope :favourite, -> { where(favourite: true) }
  scope :active,    -> { where.not(state: :stopped) }

  def instrument_already_trading?
    account.user_strategies.joins(:strategy).where('strategies.instrument = ?', instrument).started.any?
  end

  def take_profit_at
    self[:take_profit_at] || default_config[:take_profit_at]
  end

  def stop_loss_at
    self[:stop_loss_at] || default_config[:stop_loss_at]
  end

  def margin
    self[:margin] # || default_config[:margin]
  end

  def chart_interval
    self[:chart_interval] || default_config[:chart_interval]
  end

  def units
    self[:units] || default_config[:units]
  end

  def consecutive_losses_allowed
    self[:consecutive_losses_allowed] || default_config[:consecutive_losses_allowed]
  end

  # TODO: When upgrading to Rails 5.1, remove and see if the UTC time from the DB is converted to the timezone.
  def cut_off_time
    self[:cut_off_time].try(:in_time_zone) || market_close_at
  end

  # TODO: When upgrading to Rails 5.1, remove and see if the time is converted from the timezone to UTC before saving to DB.
  def cut_off_time=(value)
    self[:cut_off_time] = Time.new(*value.to_a.sort.collect{ |array| array[1] })
  end
end
