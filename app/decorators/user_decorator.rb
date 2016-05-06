class UserDecorator < Draper::Decorator
  delegate *%i(name id)

  def followers
    object.followers.map(&:decorate).map(&:attributes)
  end
end
