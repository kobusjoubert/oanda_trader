module GravatarHelper
  def gravatar_image_url(email, size: 80, default: 'identicon', rating: 'g')
    email_hash = Digest::MD5.hexdigest(email.downcase.strip)
    "https://www.gravatar.com/avatar/#{email_hash}?s=#{size}&d=#{default}&r=#{rating}"
  end

  def gravatar_image_tag(email, **options)
    size = options.delete(:size) || 80
    url = gravatar_image_url(email, size: size)
    css_classes = options.delete(:class)

    # Build img tag HTML with proper attribute handling
    img_attrs = ["src=\"#{url}\""]
    img_attrs << "alt=\"#{ERB::Util.h(email)}\""
    img_attrs << "class=\"#{ERB::Util.h(css_classes)}\"" if css_classes

    # Add any remaining options as properly escaped attributes
    options.each do |key, value|
      img_attrs << "#{key}=\"#{ERB::Util.h(value)}\""
    end

    raw("<img #{img_attrs.join(' ')}>")
  end
end
