// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  // Connects to socket URI specified in <meta name="action-cable-url" content="ws://.../cable"> using
  // the action_cable_meta_tag view helper which in turns gets the URI from config.action_cable.url
  App.cable = ActionCable.createConsumer();
}).call(this);
