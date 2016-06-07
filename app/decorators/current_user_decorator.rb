class CurrentUserDecorator
  def initialize(user)
    @user = user
  end

  def facebook_account
    @user.facebook_account
  end

  def href
    if @user.nil?
      root_path
    else
      h.user_path(@user)
    end
  end

  def profile_pic
    decorated.profile_pic
  end

  def as_prop
    {
      id:   @user.id,
      name: @user.name,
      href: href
    }
  end

  def name
    @user.name
  end

  def id
    @user.id
  end

  def render
    return nil if @user.nil?
    decorated.as_prop
  end

  def decorated
    @user.decorate
  end

  def follows?(leader)
    return false if @user.nil?
    @user.follows?(leader)
  end

  def friends_with?(user)
    return false if @user.nil?
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
