module GravatarHelper
  def gravatar_image_url(email, size: 80, default: 'identicon', rating: 'g')
    email_hash = Digest::MD5.hexdigest(email.downcase.strip)
    "https://www.gravatar.com/avatar/#{email_hash}?s=#{size}&d=#{default}&r=#{rating}"
  end

  def gravatar_image_tag(email, **options)
    url = gravatar_image_url(email, size: (options.delete(:size) || 80))
    image_tag(url, **options)
  end
end
