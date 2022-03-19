class WarningChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber of this channel. 
  # This method is responsible for subscribing to and streaming messages that are broadcast to this channel.
  #
  # warning.js
  #   App.cable.subscriptions.create('WarnginChannel' ...
  def subscribed
    stream_from("user_#{current_user.id}_warnings")
  end
end
