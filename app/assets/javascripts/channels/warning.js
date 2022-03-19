App.warning = App.cable.subscriptions.create('WarningChannel', {
  connected: function() {
    // Called when the subscription is ready for use on the server.
  },
  disconnected: function() {
    // Called when the WebSocket connection is closed.
  },
  rejected: function() {
    // Called when the subscription is rejected by the server.
  },
  received: function(data) {
    // Called by stream_from in WarnginsChannel.
    if (data.replace == true) {
      this.replaceFlash(data);
    } else {
      this.addFlash(data);
    }
    this.playSound(data);
  },
  addFlash: function(data) {
    var html;
    html = this.createFlash(data);
    return $('#flash-messages').append(html);
  },
  replaceFlash: function(data) {
    var html;
    html = this.createFlash(data);
    return $('#flash-messages').html(html);
  },
  createFlash: function(data) {
    return '<div class="alert alert-' + data.level + '"><button class="close" type="button" aria-hidden="true" data-dismiss="alert">&times;</button><div id="flash-warning">' + data.message + '</div></div>'
  },
  playSound: function(data) {
    if (data.level == 'danger')
      return $('.sound-fire')[0].play();
  }
});
