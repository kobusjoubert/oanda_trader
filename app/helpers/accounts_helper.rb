module AccountsHelper
  def account_practice_or_live_class(account)
    account ? account.practice? ? 'success' : 'danger' : 'secondary'
  end

  def account_active_class(account)
    account.current? ? 'primary' : 'default'
  end

  def account_practice_or_live_icon(account)
    account.practice? ? content_tag(:span, t('practice_account'), class: "badge badge-success") : content_tag(:span, t('live_account'), class: "badge badge-danger")
  end

  def account_max_concurrent_trades_icon(account)
    account.practice? ? content_tag(:span, account.max_concurrent_trades, class: "badge badge-success", title: t('max_concurrent_trades'), data: { toggle: "tooltip" }) : content_tag(:span, account.max_concurrent_trades, class: "badge badge-danger", title: t('max_concurrent_trades'), data: { toggle: "tooltip" })
  end

  def account_margin_clouseout_percent_icon(account)
    margin_state = 'success'
    margin_state = 'warning' if account.margin_closeout_percent >= 50
    margin_state = 'danger' if account.margin_closeout_percent >= 75
    content_tag(:span, "#{account.margin_closeout_percent}%", class: "progress-bar bg-#{margin_state}", role: "progressbar", title: t('margin_closeout_percent'), style: "width: #{account.margin_closeout_percent}%;", data: { toggle: "tooltip" }, area: { valuenow: account.margin_closeout_percent, valuemin: 0, valuemax: 100 })
  end

  def account_id(account)
    account.trade_account_id.presence || '--'
  end

  def account_alias(account)
    account.alias.presence || t('account')
  end

  def account_balance(account)
    account.balance.present? ? "$ #{account.balance}" : "$ 0"
  end
end
