module Charts
  class History
    include ActiveModel::Model

    attr_accessor :symbol, :from, :to, :resolution, :current_user, :smooth
    attr_reader   :candles, :status, :error_message, :next_time, :times, :volumes, :opens, :highs, :lows, :closes

    def initialize(options = {})
      options.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end

      @times   = []
      @volumes = []
      @opens   = []
      @highs   = []
      @lows    = []
      @closes  = []
      @from    = from.to_i
      @to      = to.to_i
      @to      = Time.now.utc.to_i - 60 if to > Time.now.utc.to_i

      candle_options = {
        granularity: TRADING_VIEW_RESOLUTIONS[resolution],
        price:       'MAB',
        smooth:      smooth.nil? ? true : smooth,
        from:        from,
        to:          to
      }

      re_request_candles       = true
      re_request_candles_count = 0

      while re_request_candles && re_request_candles_count < 5
        begin
          re_request_candles = false
          @status            = nil
          @candles           = current_user.current_account.oanda_client.instrument(symbol).candles(candle_options).show
        rescue OandaApiV20::RequestError => e
          re_request_candles       = true
          re_request_candles_count += 1
          exception = Http::ExceptionsParser.new(e)
          raise e unless exception.response.code == 400
          @error_message = JSON.parse(exception.response.body)['errorMessage']
          @status        = 'error'

          if error_message == "Invalid value specified for 'to'. Time is in the future"
            candle_options.merge!(to: Time.now.utc.to_i - 60)
          end

          if error_message == "Maximum value for 'count' exceeded"
            max_count  = 500 # Used to be 5_000, now only 500. Started being an issue Jan 2019! Oanda API all or the sudden started returning this error when requesting more than 500 candles.
            updated_to = from.to_i + max_count * CANDLESTICK_GRANULARITY_IN_SECONDS[candle_options[:granularity]]
            updated_to = Time.now.utc.to_i - 60 if updated_to > Time.now.utc.to_i
            candle_options.merge!(to: updated_to)
          end
        end
      end

      return if status == 'error'

      if candles && candles['candles'].count > 0
        @status = 'ok'

        candles['candles'].each do |candle|
          begin
            time = Time.parse(candle['time']).utc
          rescue ArgumentError, TypeError
            time = Time.at(candle['time'].to_i).utc
          end

          @times   << time.to_i
          @volumes << candle['volume'].to_i
          @opens   << candle['mid']['o'].to_f
          @highs   << candle['mid']['h'].to_f
          @lows    << candle['mid']['l'].to_f
          @closes  << candle['mid']['c'].to_f
        end
      else
        @status = 'no_data'

        # Search at least 5 days back. This should be more than enough to cover a weekend with 3 days of holiday.
        for i in 0..5
          @to      = from.to_i
          @from    = (from.to_i - 1.day.to_i).to_i
          @candles = current_user.current_account.oanda_client.instrument(symbol).candles(candle_options.merge!(from: from, to: to)).show

          if @candles['candles'].count > 0
            begin
              time = Time.parse(candles['candles'].last['time']).utc
            rescue ArgumentError, TypeError
              time = Time.at(candles['candles'].last['time'].to_i).utc
            end

            @next_time = time.to_i * 1_000
            break
          end
        end
      end
    end
  end
end
