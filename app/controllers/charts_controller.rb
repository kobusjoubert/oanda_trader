class ChartsController < ApplicationController
  layout 'application_fullscreen'

  # HTML

  # GET /charts
  def index
  end

  # JSON

  # Do not use config as method name.
  #   https://github.com/kobusjoubert/tv_chart_rails#note
  #
  # GET /charts/config
  def charts_config
    @config = Charts::Config.new
  end

  # GET /charts/symbols
  def symbols
    @symbol = Charts::Symbol.new(symbol: params[:symbol])
  end

  # GET /charts/search
  def search
    @symbols = Instrument.where(
      'name LIKE :query AND type = :type AND exchange = :exchange',
      query: "%#{params[:query]}%",
      type: params[:type].presence || 'forex',
      exchange: params[:exchange].presence || 'OANDA'
    ).limit((params[:limit] || 1).to_i)
  end

  # GET /charts/history
  def history
    smooth = true

    if params[:symbol].include?('*')
      smooth = false 
      params[:symbol] = params[:symbol].gsub('*', '')
    end

    @history = Charts::History.new(params.merge(current_user: current_user, smooth: smooth))
  end

  # GET /charts/marks
  def marks
  end

  # GET /charts/timescale_marks
  def timescale_marks
  end

  # GET /charts/time
  def time
    render plain: Time.now.utc.to_i
  end

  # GET /charts/quotes
  def quotes
  end
end
