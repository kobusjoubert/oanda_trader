class ProgressChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber of this channel. 
  # This method is responsible for subscribing to and streaming messages that are broadcast to this channel.
  #
  # progress.js
  #   App.cable.subscriptions.create('ProgressChannel' ...
  def subscribed
    stream_from("user_#{current_user.id}_progress")
  end
end
