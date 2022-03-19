App.activity = App.cable.subscriptions.create('ActivityChannel', {
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
    // Called by stream_from in ActivitiesChannel.
    this.addCardRow(data);
    this.addTableRow(data);
    this.playSound(data);
  },
  addCardRow: function(data) {
    var html;
    html = this.createCardRow(data);
    return $('#strategy-' + data.strategy_id + ' .activities-table table tbody').hide().prepend(html).fadeIn('fast');
  },
  createCardRow: function(data) {
    return '<tr class="table-' + data.level + '"><td class="text-truncate">' + data.comment + '</td><td class="text-truncate"><div class="float-right">' + data.published_at + '</div></td></tr>';
  },
  addTableRow: function(data) {
    var html;
    html = this.createTableRow(data);
    return $('#strategy-' + data.strategy_id + ' .user-strategy-activities-table table tbody').hide().prepend(html).fadeIn('fast');
  },
  createTableRow: function(data) {
    return '<tr class="table-' + data.level + '"><td class="text-truncate">' + data.comment + '</td><td class="text-truncate"><div class="float-right">' + data.created_at + '</div></td><td class="text-truncate"><div class="float-right">' + data.published_at + '</div></td></tr>';
  },
  playSound: function(data) {
    // Skip when backtesting.
    if (App.cable.connection.webSocket.URL.includes('3001'))
      return;
    if (data.level == 'secondary')
      return $('.sound-button-press')[0].play();
    if (data.level == 'info')
      return $('.sound-bubble')[0].play();
    if (data.level == 'success')
      return $('.sound-cash-register')[0].play();
    if (data.level == 'danger')
      return $('.sound-punch')[0].play();
  }
});
