require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OandaTrader
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Pretoria'

    # Let active record return datetime values instead of nil.
    # config.active_record.default_timezone = :local
    # config.active_record.time_zone_aware_attributes = false

    # Time columns will become time zone aware in Rails 5.1. This
    # still causes `String`s to be parsed as if they were in `Time.zone`,
    # and `Time`s to be converted to `Time.zone`.
    #
    # To keep the old behavior, you must add the following to your initializer:
    #
    #     config.active_record.time_zone_aware_types = [:datetime]
    #
    # To silence this deprecation warning, add the following:
    #
    #     config.active_record.time_zone_aware_types = [:datetime, :time]
    #
    config.active_record.time_zone_aware_types = [:datetime, :time]

    # Background processing.
    config.active_job.queue_adapter = :sneakers

    # Additional assets.
    # NOTE: This is now handled in app/assets/config/manifest.js
    #   http://eileencodes.com/posts/the-sprockets-4-manifest/
    #
    # config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # Environment configs.
    config.devise = config_for(:devise)
    config.trading_view = config_for(:trading_view)
  end
end
