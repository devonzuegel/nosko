module ApplicationHelper
  def link_fa_to(icon_name, link, text = nil)
    link_to content_tag(:i, text, :class => "fa fa-#{icon_name}"), link
  end

  def icon_link(icon_name, link, text = nil, classes: [])
    innertext      = text.nil? ? nil : content_tag(:div, text, :class => 'icon-text')
    contextclasses = "ion-icon ion-#{icon_name} #{classes.join(' ')}"
    link_to link do
      content_tag :div do
        content_tag(:div, nil, :class => contextclasses) + content_tag(:div, text, :class => 'icon-text')
      end
    end
  end
end
