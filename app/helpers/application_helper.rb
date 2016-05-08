module ApplicationHelper
  def icon_link(icon_name, link, text = nil, classes: [])
    icon = content_tag(:div, nil, :class => "ion-icon ion-#{icon_name}")
    text = content_tag(:div, text, :class => 'icon-text')

    link_to link do
      content_tag :div, :class => classes.join(' ') { icon + text }
    end
  end
end
