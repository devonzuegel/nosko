class Finding::ArticleDecorator < Draper::Decorator
  delegate *%i(id content title source_url updated_at)

  def href
    h.finding_path(object)
  end

  def as_prop
    {
      id:          id,
      title:       title,
      content:     content,
      source_url:  source_url,
      href:        href
    }
  end
end
