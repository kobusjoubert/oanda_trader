json.nextTime @history.next_time if @history.next_time
json.s @history.status if @history.status
json.v @history.volumes if @history.volumes.present?
json.t @history.times if @history.times.present?
json.o @history.opens if @history.opens.present?
json.h @history.highs if @history.highs.present?
json.l @history.lows if @history.lows.present?
json.c @history.closes if @history.closes.present?
json.errmsg @history.error_message if @history.error_message