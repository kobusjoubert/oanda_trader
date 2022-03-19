module Charts
  class Config
    include ActiveModel::Model

    attr_reader :supports_search, :supports_group_request, :supports_marks, :supports_timescale_marks, :supports_time, :exchanges, :supported_resolutions

    def initialize(options = {})
      @supports_search          = true
      @supports_group_request   = false
      @supports_marks           = false
      @supports_timescale_marks = false
      @supports_time            = true
      @exchanges                = [{ value: '', name: 'All Exchanges', desc: '' }, { value: 'OANDA - Forex', name: 'OANDA', desc: 'Forex' }]
      @supported_resolutions    = ['5S', '10S', '15S', '30S', '1', '5', '10', '15', '30', '60', '120', '180', '240', '360', '480', '720', '1D', '1W', '1M']
    end
  end
end
