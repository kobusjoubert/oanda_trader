module ApplicationHelper
  def flash_status(name)
    case name.to_sym
    when :alert, :error
      'danger'
    when :notice
      'success'
    else
      name
    end
  end

  def active_class(path)
    return 'active' if request.path == path
    ''
  end

  def live_or_practice
    return 'default' unless user_signed_in?
    return 'default' unless current_user.current_account
    current_user.current_account.practice? ? 'practice' : 'live' 
  end

  def body_classes(classes = nil)
    ary = [Rails.application.class.to_s.split('::').first.downcase]
    ary << controller.controller_name
    ary << controller.action_name
    ary << 'mobile' if mobile_agent?

    unless classes.nil?
      method = classes.is_a?(Array) ? :concat : :<<
      ary.send method, classes
    end

    ary.join(' ')
  end

  def mobile_agent?
    return true if params[:mobile] == '1'
    request.user_agent =~ /Mobile|webOS/
  end

  def brand_icon_path
    user_signed_in? ? favourites_strategies_path : root_path
  end
end
