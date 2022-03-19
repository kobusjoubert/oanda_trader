class StrategyProgressJob < ApplicationJob
  from_queue :qt_strategy_progress

  def work(msg)
    data = JSON.parse(msg)
    create_progress(data) ? ack! : requeue!
  rescue Timeout::Error, ActiveRecord::ConnectionTimeoutError => e
    Sneakers.logger.error "ERROR! StrategyProgressJob.create_progress(data): #{data}, EXCEPTION: #{e.inspect}"
    requeue!
  end

  private

  def create_progress(data)
    data.symbolize_keys!

    unless data[:account] && data[:percentage] && !data[:practice].nil?
      raise ArgumentError, "Some attributes are missing. The following are needed: data[:practice], data[:account] & data[:percentage]. These were given: #{data}"
    end

    account = Account.find_by!(trade_account_id: data[:account], practice: data[:practice])

    message_data = {
      percentage: data[:percentage],
      level: data[:level] || :info
    }

    ActionCable.server.broadcast("user_#{account.user.id}_progress", message_data)
    true
  end
end
