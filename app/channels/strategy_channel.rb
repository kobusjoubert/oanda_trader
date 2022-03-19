class StrategyChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber of this channel. 
  # This method is responsible for subscribing to and streaming messages that are broadcast to this channel.
  #
  # strategy.js
  #   App.cable.subscriptions.create('StrategyChannel' ...
  def subscribed
    stream_from("user_#{current_user.id}_strategies")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def start(data)
    user_strategy = UserStrategy.find(data['id'])

    if user_strategy.instrument_already_trading?
      ActionCable.server.broadcast("user_#{current_user.id}_warnings", message: 'Another strategy is already trading this instrument', level: :danger)

      channel_data = {
        strategy_id:  user_strategy.strategy.id,
        buttons_html: render_buttons(user_strategy.strategy, user_strategy),
        border:       'danger'
      }

      ActionCable.server.broadcast("user_#{current_user.id}_strategies", channel_data)
    else
      StrategyPublish.publish_to_worker(user_strategy, data['action'])
    end
  end

  def pause(data)
    user_strategy = UserStrategy.find(data['id'])
    StrategyPublish.publish_to_worker(user_strategy, data['action'])
  end

  def stop(data)
    user_strategy = UserStrategy.find(data['id'])
    StrategyPublish.publish_to_worker(user_strategy, data['action'])
  end

  private

  def render_buttons(strategy, user_strategy)
    ApplicationController.render(partial: 'strategies/buttons_worker', locals: { strategy: strategy, user_strategy: user_strategy })
  end
end
