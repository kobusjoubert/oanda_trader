module ActivitiesHelper
  def column_chart_data(user_strategy, measure)
    profits = []
    losses  = []

    case measure
    when 'year'
      range         = 1.year.ago.midnight..Time.now
      profit_losses = user_strategy.activities.positions.closed.group_by_month(:published_at, range: range, format: '%b').sum(:profit_loss)
    when 'week'
      range         = 1.week.ago.midnight..Time.now
      profit_losses = user_strategy.activities.positions.closed.group_by_day(:published_at, range: range, format: '%a').sum(:profit_loss)
      profit_losses.map do |key, value|
        profit_losses.delete(key) if ['Sun', 'Sat'].include?(key)
      end
    else
      range         = Time.parse("#{measure.to_i - 1}-12-31").midnight..Time.parse("#{measure.to_i}-12-31").midnight
      profit_losses = user_strategy.activities.positions.closed.group_by_month(:published_at, range: range, format: '%b').sum(:profit_loss)
    end

    first = profit_losses.shift
    profit_losses.merge!(first[0] => first[1])
    profit_losses = Hash[profit_losses.to_a.reverse]

    for i in 0..profit_losses.count - 1
      title = profit_losses.to_a[i][0]
      value = profit_losses.to_a[i][1].to_f

      if profit_losses.to_a[i][1] >= 0
        profits[i] = [title, value]
        losses[i]  = [title, 0.to_f]
      else
        profits[i] = [title, 0.to_f]
        losses[i]  = [title, value.abs]
      end
    end

    [{ name: 'Profit', data: profits }, { name: 'Loss', data: losses }]
  end
end
