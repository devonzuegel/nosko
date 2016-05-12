class UserDecorator < Draper::Decorator
  delegate *%i(id name articles)

  def followers
    object.followers.map(&:decorate).map(&:as_prop)
  end

  def href
    h.user_path(object)
  end

  def num_findings_this_month
    num = articles.where(created_at: Time.zone.now.all_month).count
    h.number_with_delimiter(num)
  end

  def num_words_this_week
    num = articles.map { |a| a.content.length }.reduce(&:+)
    h.number_with_delimiter(num)
  end

  def as_prop
    {
      id:                       id,
      name:                     name,
      href:                     href,
      num_findings_this_month:  num_findings_this_month,
      num_words_this_week:      num_words_this_week
    }
  end
end
