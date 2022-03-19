class StrategyWarningJob < ApplicationJob
  from_queue :qt_strategy_warning

  def work(msg)
    data = JSON.parse(msg)
    create_warning(data) ? ack! : requeue!
  rescue Timeout::Error, ActiveRecord::ConnectionTimeoutError => e
    Sneakers.logger.error "ERROR! StrategyWarningJob.create_warning(data): #{data}, EXCEPTION: #{e.inspect}"
    requeue!
  end

  private

  def create_warning(data)
    data.symbolize_keys!

    unless data[:account] && data[:message] && !data[:practice].nil?
      raise ArgumentError, "Some attributes are missing. The following are needed: data[:practice], data[:account] & data[:message]. These were given: #{data}"
    end

    account = Account.find_by!(trade_account_id: data[:account], practice: data[:practice])

    message_data = {
      message: "#{Time.zone.now.to_s(:short)} #{data[:message]}",
      level: data[:level] || :danger,
      replace: data[:replace] || false
    }

    ActionCable.server.broadcast("user_#{account.user.id}_warnings", message_data)
    true
  end
end
