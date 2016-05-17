class UserDecorator < Draper::Decorator
  delegate *%i(id name)

  def followers
    object.followers.map(&:decorate).map(&:as_prop)
  end

  def articles(offset: 0, limit: 10)
    object.articles.first(limit).map { |a| a.decorate.as_prop }
  end

  def href
    h.user_path(object)
  end

  def findings_this_month
    object.articles.where(created_at: Time.zone.now.all_month)
  end

  def findings_this_week
    object.articles.where(created_at: Time.zone.now.all_week)
  end

  def num_findings_this_month
    h.number_with_delimiter(findings_this_month.count)
  end

  def num_words_this_week
    num = findings_this_week.map { |a| a.content.length }.reduce(&:+)
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

  def as_settings_prop
    object.attributes.merge(sharing: object.sharing.as_json)
  end
end
