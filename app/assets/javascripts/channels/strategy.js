App.strategy = App.cable.subscriptions.create('StrategyChannel', {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    $('#strategy-' + data.strategy_id + '-buttons-worker').html(data.buttons_html);
    $('#strategy-' + data.strategy_id).removeClass('border-primary border-warning border-danger border-info border-default').addClass('border-' + data.border);
  },
  start: function(id) {
    return this.perform('start', { id: id });
  },
  pause: function(id) {
    return this.perform('pause', { id: id });
  },
  stop: function(id) {
    return this.perform('stop', { id: id });
  }
});
