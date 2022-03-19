class StrategyPublish
  class << self
    def publish_to_worker(user_strategy, action_or_status)
      data = {
        action: 'update_redis_keys',
        status: status(action_or_status),
        account: user_strategy.account.trade_account_id,
        practice: user_strategy.account.practice,
        strategy: user_strategy.worker_name,
        config: {
          units: user_strategy.units,
          margin: user_strategy.margin,
          chart_interval: user_strategy.chart_interval,
          consecutive_losses_allowed: user_strategy.consecutive_losses_allowed,
          trade_from: user_strategy.trade_from.utc,
          trade_to: user_strategy.trade_to.utc,
          exit_friday_at: user_strategy.exit_friday_at.try(:utc)
        }
      }

      $rabbitmq_exchange.publish(data.to_json, routing_key: 'qw_strategy_update')
    end

    private

    def status(action_or_status)
      case action_or_status
      when 'start'
        'started'
      when 'pause'
        'paused'
      when 'stop'
        'stopped'
      else
        action_or_status
      end
    end
  end
end
