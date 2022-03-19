module StrategiesHelper
  def strategy_active_class(strategy)
    user_strategy = current_user.current_account.user_strategies.where(strategy: strategy).last
    return 'default' unless user_strategy

    case user_strategy.state
    when 'started'
      'primary'
    when 'paused'
      'warning'
    when 'halted'
      'danger'
    when 'temporary_halted'
      'info'
    when 'stopped'
      'default'
    end
  end

  def strategy_worker_name(strategy)
    content_tag(:span, "#{strategy.worker_name}", class: "badge badge-secondary", title: t('worker_name'), data: { toggle: 'tooltip' })
  end

  def strategy_instrument(strategy)
    content_tag(:span, "#{strategy.instrument}", class: "badge badge-secondary", title: t('instrument'), data: { toggle: 'tooltip' })
  end

  def strategy_chart_interval(strategy)
    content_tag(:span, "#{CANDLESTICK_GRANULARITY[(current_user.current_account.user_strategies.where(strategy: strategy).last.try(:chart_interval) || strategy.default_config[:chart_interval])]}", class: "badge badge-info", title: t('chart_interval'), data: { toggle: 'tooltip' })
  end

  def strategy_units_or_percentage(strategy)
    user_strategy       = current_user.current_account.user_strategies.where(strategy: strategy).last
    units_or_percentage = user_strategy ? user_strategy.margin ? "#{user_strategy.margin}%" : user_strategy.units : strategy.default_config[:margin] ? "#{strategy.default_config[:margin]}%" : strategy.default_config[:units]
    title               = user_strategy ? user_strategy.margin ? t('balance_percentage') : t('units') : strategy.default_config[:margin] ? t('balance_percentage') : t('units')  
    content_tag(:span, units_or_percentage, class: "badge badge-success", title: title, data: { toggle: 'tooltip' })
  end

  def strategy_exit_hours(strategy)
    return nil unless strategy.exit_friday_at
    content_tag(:span, "#{strategy.exit_friday_at.to_s(:time)}", class: "badge badge-warning", title: t('exit_friday_at'), data: { toggle: 'tooltip' })
  end

  def strategy_consecutive_losses_allowed(strategy)
    content_tag(:span, "#{current_user.current_account.user_strategies.where(strategy: strategy).last.try(:consecutive_losses_allowed) || strategy.default_config[:consecutive_losses_allowed]}", class: "badge badge-danger", title: t('consecutive_losses_allowed'), data: { toggle: 'tooltip' })
  end

  def strategy_take_profit_icon(strategy)
    content_tag(:span, "TP #{current_user.current_account.user_strategies.where(strategy: strategy).last.try(:take_profit_at) || strategy.default_config[:take_profit_at]}", class: "badge badge-success", title: t('take_profit'), data: { toggle: 'tooltip' })
  end

  def strategy_stop_loss_icon(strategy)
    content_tag(:span, "SL #{current_user.current_account.user_strategies.where(strategy: strategy).last.try(:stop_loss_at) || strategy.default_config[:stop_loss_at]}", class: "badge badge-danger", title: t('stop_loss'), data: { toggle: 'tooltip' })
  end

  def strategy_margin_icon(strategy)
    content_tag(:span, "M #{current_user.current_account.user_strategies.where(strategy: strategy).last.try(:margin) || strategy.default_config[:margin]}", class: "badge badge-warning", title: t('margin'), data: { toggle: 'tooltip' })
  end

  def strategy_config_path(strategy)
    if config = current_user.current_account.user_strategies.find_by_strategy_id(strategy.id)
      edit_strategy_user_strategy_path(strategy.id, config.id)
    else
      new_strategy_user_strategy_path(strategy.id)
    end
  end
end
