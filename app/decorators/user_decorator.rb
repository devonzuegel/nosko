class UserDecorator < Draper::Decorator
  delegate *%i(id name articles)

  def followers
    object.followers.map(&:decorate).map(&:as_prop)
  end

  def href
    h.user_path(object)
  end

  def as_prop
    {
      id:    id,
      name:  name,
      href:  href
    }
  end
end
