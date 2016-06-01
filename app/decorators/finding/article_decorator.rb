class Finding::ArticleDecorator < Draper::Decorator
  delegate_all

  def href
    path = h.finding_path(object)[1..-1]
    "#{h.root_url}#{path}"
  end

  def as_prop(current_user = nil)
    {
      title:       title,
      content:     content.gsub("\r\n","<br/>"),
      source_url:  source_url,
      href:        href,
      locked:      locked?,
      to_param:    to_param,
      user:        user.decorate.as_prop,
      visibility:  visibility,
      updated_at:  "#{h.time_ago_in_words(updated_at).capitalize} ago",
      editable:    h.current_user == user
    }
  end
end
