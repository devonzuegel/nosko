module ApplicationHelper
  def icon_link(icon_name, link, text = nil, classes: [])
    link_to link do
      content_tag :div, :class => classes.join(' ') do
        content_tag(:div, nil, :class => "ion-icon ion-#{icon_name}") + content_tag(:div, text, :class => 'icon-text')
      end
    end
  end
end
