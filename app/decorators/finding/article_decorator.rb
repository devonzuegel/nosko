class Finding::ArticleDecorator < Draper::Decorator
  delegate_all

  def href
    path = h.finding_path(object)[1..-1]
    "#{h.root_url}#{path}"
  end

  def as_prop
    {
      id:          id,
      title:       title,
      content:     content.gsub("\r\n","<br/>"),
      source_url:  source_url,
      href:        href,
      updated_at:  h.time_ago_in_words(updated_at)
    }
  end
end
