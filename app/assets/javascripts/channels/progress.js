App.progress = App.cable.subscriptions.create('ProgressChannel', {
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
    // Called by stream_from in ProgressChannel.
    this.updateProgressBar(data);
    this.playSound(data);
  },
  updateProgressBar: function(data) {
    var html;
    html = this.createProgressBar(data);
    return $('#progress-bar').html(html);
  },
  createProgressBar: function(data) {
    return '<div class="progress"><div class="progress-bar bg-' + data.level + '" role="progressbar" style="width: ' + data.percentage + '%" aria-valuenow="' + data.percentage + '" aria-valuemin="0" aria-valuemax="100">' + data.percentage + '%</div></div>'
  },
  playSound: function(data) {
    if (data.level == 'success' && data.percentage == 100)
      return $('.sound-bell')[0].play();
    if (data.level == 'info' && data.percentage == 100)
      return $('.sound-button-press-2')[0].play();
  }
});
