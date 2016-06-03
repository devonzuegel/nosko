class Finding::ArticleDecorator < Draper::Decorator
  delegate_all

  def href
    path = h.finding_path(object)[1..-1]
    "#{h.root_url}#{path}"
  end

  def label_type
    case visibility
      when 'Only me' then 'label-primary'
      when 'Friends' then 'label-info'
      when 'Public'  then 'label-success'
      else 'label-default'
    end
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
      created_at:  "#{h.time_ago_in_words(created_at).capitalize} ago",
      editable:    h.current_user == user,
      label_type:  label_type
    }
  end
end
