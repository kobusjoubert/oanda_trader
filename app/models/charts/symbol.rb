module Charts
  class Symbol
    include ActiveModel::Model

    attr_reader :name, :ticker, :description, :type, :session, :exchange, :listed_exchange, :minmov, :minmove2, :pricescale, :fractional,
                :timezone, :has_intraday, :has_seconds, :has_daily, :has_weekly_and_monthly, :supported_resolutions, :intraday_multipliers,
                :has_empty_bars, :force_session_rebuild, :has_no_volume, :volume_precision, :data_status, :expired #, :currency_code

    def initialize(options = {})
      if options[:symbol].include?(':')
        exchange, name = options[:symbol].split(':')
      else
        name = options[:symbol]
      end

      instrument              = exchange ? Instrument.find_by(name: name, exchange: exchange) : Instrument.find_by(name: name)
      @name                   = instrument.name
      @ticker                 = instrument.ticker
      @description            = instrument.description
      @type                   = instrument.type
      @session                = instrument.session
      @exchange               = instrument.exchange
      @listed_exchange        = instrument.listed_exchange
      @minmov                 = instrument.min_movement
      @minmove2               = instrument.min_movement_2
      @pricescale             = instrument.price_scale
      @fractional             = instrument.fractional
      @timezone               = 'Africa/Johannesburg'
      @has_intraday           = true
      @has_seconds            = true
      @has_daily              = true
      @has_weekly_and_monthly = true
      @supported_resolutions  = ['5S', '10S', '15S', '30S', '1', '5', '10', '15', '30', '60', '120', '180', '240', '360', '480', '720', '1D', '1W', '1M']
      # @intraday_multipliers   = ['1', '5', '10', '15', '30', '60', '120', '180', '240', '360', '480', '720']
      @has_empty_bars         = true
      @force_session_rebuild  = false
      @has_no_volume          = false
      @volume_precision       = 0
      @data_status            = 'endofday'
      @expired                = false
      # @currency_code          = '$'
    end
  end
end
