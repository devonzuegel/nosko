class CurrentUserDecorator < Draper::Decorator
  decorates :user
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

  def friends_with?(user)
    return false if object.nil?
    matches = [
      *Friendship.where(friender_id: user, friendee_id: id).confirmed,
      *Friendship.where(friender_id: id,   friendee_id: user).confirmed
    ]
    !matches.empty?
  end

  def request_pending?(user)
    unconfirmed_friends =     [
      *Friendship.where(friendee_id: id).unconfirmed.map(&:friender),
      *Friendship.where(friender_id: id).unconfirmed.map(&:friendee)
    ]
    unconfirmed_friends.map(&:id).include? user.id
  end
end
