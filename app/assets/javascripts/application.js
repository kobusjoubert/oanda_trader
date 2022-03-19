// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require tether
//= require bootstrap-sprockets
//= require jquery_ujs
//= require twitter/bootstrap/rails/confirm
//= require Chart.bundle
//= require chartkick
//= require turbolinks
//= require_tree .
//= require_tree ./channels

// Modal.
$.fn.twitter_bootstrap_confirmbox.defaults = {
  fade: true,
  title: 'Confirm',
  cancel: 'Cancel',
  proceed: 'OK',
  cancel_class: 'btn cancel',
  proceed_class: 'btn proceed btn-outline-primary'
};


$(document).on('turbolinks:load', function() {
  // Tooltips.
  $('[data-toggle="tooltip"]').tooltip()

  // Profile Dropdown.
  $('#user-dropdown').on('shown.bs.dropdown', function() {
    $.ajax({
      url: '/accounts/refresh_current',
      method: 'PATCH'
    });
  });

  $('#user-dropdown').on('shown.bs.dropdown', function() {
    $('#current-balance').append('<i class="fa fa-refresh fa-spin fa-1x fa-fw margin-bottom"></i>');
  });
});
