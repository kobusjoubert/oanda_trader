class StrategyActivityJob < ApplicationJob
  from_queue :qt_strategy_activity

  def work(msg)
    data = JSON.parse(msg)
    create_activity(data) ? ack! : requeue!
  rescue Timeout::Error, ActiveRecord::ConnectionTimeoutError => e
    Sneakers.logger.error "ERROR! StrategyActivityJob.create_activity(data): #{data}, EXCEPTION: #{e.inspect}"
    requeue!
  end

  private

  def create_activity(data)
    data.symbolize_keys!

    unless data[:account] && data[:strategy] && !data[:practice].nil?
      raise ArgumentError, "Some attributes are missing. The following are needed: data[:practice], data[:account] & data[:strategy]. These were given: #{data}"
    end

    account       = Account.find_by!(trade_account_id: data[:account], practice: data[:practice])
    strategy      = Strategy.find_by!(worker_name: data[:strategy])
    user_strategy = UserStrategy.where(account: account, strategy: strategy).order(id: :desc).take!

    activity_data = {
      published_at:   data[:published_at],
      level:          data[:level],
      comment:        data[:message],
      position:       data[:position],
      action:         data[:action],
      units:          data[:units],
      price:          data[:price],
      take_profit:    data[:take_profit],
      stop_loss:      data[:stop_loss],
      transaction_id: data[:transaction_id],
      profit_loss:    data[:profit_loss]
    }

    activity = user_strategy.activities.create(activity_data)

    channel_data = {
      user_strategy_id: user_strategy.id,
      strategy_id:      strategy.id,
      comment:          activity.comment,
      level:            data[:level],
      status:           data[:status],
      created_at:       activity.created_at.to_s(:time_long),
      published_at:     activity.published_at.to_s(:time_long)
    }

    ActionCable.server.broadcast("user_#{account.user.id}_activities", channel_data)
    true
  end
end
