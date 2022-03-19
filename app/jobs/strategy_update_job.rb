class StrategyUpdateJob < ApplicationJob
  from_queue :qt_strategy_update, timeout_job_after: 3600

  def work(msg)
    data = JSON.parse(msg)
    update_strategy(data) ? ack! : requeue!
  rescue Timeout::Error, ActiveRecord::ConnectionTimeoutError => e
    Sneakers.logger.error "ERROR! StrategyUpdateJob.update_strategy(data): #{data}, EXCEPTION: #{e.inspect}"
    requeue!
  end

  private

  def update_strategy(data)
    data.symbolize_keys!

    unless data[:account] && data[:strategy] && data[:status] && !data[:practice].nil?
      raise ArgumentError, "Some attributes are missing. The following are needed: data[:practice], data[:account], data[:strategy] & data[:status]. These were given: #{data}"
    end

    account       = Account.find_by!(trade_account_id: data[:account], practice: data[:practice])
    strategy      = Strategy.find_by!(worker_name: data[:strategy])
    user_strategy = UserStrategy.where(account: account, strategy: strategy).order(id: :desc).take!

    if user_strategy.update_attributes(state: data[:status])
      channel_data = {
        strategy_id:  strategy.id,
        buttons_html: render_buttons(strategy, user_strategy),
        border:       strategy_active_class(data[:status])
      }

      ActionCable.server.broadcast("user_#{account.user.id}_strategies", channel_data)
      return true
    end

    false
  end

  def render_buttons(strategy, user_strategy)
    ApplicationController.render(partial: 'strategies/buttons_worker', locals: { strategy: strategy, user_strategy: user_strategy })
  end

  def strategy_active_class(state)
    case state
    when 'started'
      'primary'
    when 'paused'
      'warning'
    when 'halted'
      'danger'
    when 'temporary_halted'
      'info'
    when 'stopped'
      'default'
    end
  end
end
