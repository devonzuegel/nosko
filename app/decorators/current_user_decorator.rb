class CurrentUserDecorator < Draper::Decorator
  delegate *%i(id name facebook_account)

  def href
    if object.nil?
      root_path
    else
      h.user_path(object)
    end
  end

  def profile_pic
    decorated.profile_pic
  end

  def as_prop
    {
      id:                       id,
      name:                     name,
      href:                     href
    }
  end

  def render
    return nil if object.nil?
    decorated.as_prop
  end

  def decorated
    object.decorate
  end

  def follows?(leader)
    return false if object.nil?
    object.follows?(leader)
  end
end
