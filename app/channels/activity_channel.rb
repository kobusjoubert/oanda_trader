class ActivityChannel < ApplicationCable::Channel
  # Called when the consumer has successfully become a subscriber of this channel. 
  # This method is responsible for subscribing to and streaming messages that are broadcast to this channel.
  #
  # activity.js
  #   App.cable.subscriptions.create('ActivityChannel' ...
  def subscribed
    # stream_for(current_user)
    stream_from("user_#{current_user.id}_activities")
  end
end
