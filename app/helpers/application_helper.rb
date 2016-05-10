module ApplicationHelper
  def icon_link(icon_name, link, text = nil, classes: [], id: nil)
    icon = content_tag(:div, nil, :class => "ion-icon ion-#{icon_name}")
    text = content_tag(:div, text, :class => 'icon-text')

    link_to link, :class => classes.join(' '), id: id do
      icon + text
    end
  end
end
