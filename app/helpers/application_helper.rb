module ApplicationHelper
  def icon_link(icon_name, link, text = nil, classes: [], id: nil)
    icon = content_tag(:div, nil, :class => "ion-icon ion-#{icon_name}")
    text = content_tag(:div, text, :class => 'icon-text')

    link_to link, :class => classes.join(' '), id: id do
      icon + text
    end
  end

  def hotkeys
    [
      {
        keypress: 'up',
        symbol:   '↑',
        key_name: 'Up arrow',
        action:   'Advance to next finding or highlight'
      }, {
        keypress: 'down',
        symbol:   '↓',
        key_name: 'Down arrow',
        action:   'Move to previous finding or highlight'
      }, {
        keypress: 'right',
        symbol:   '→',
        key_name: 'Right arrow',
        action:   'Star current finding or highlight'
      }, {
        keypress: 'space',
        symbol:   'Space',
        key_name: 'Spacebar',
        action:   'Expand selected finding'
      }, {
        keypress: 'h',
        symbol:   'h',
        key_name: 'H key',
        action:   'Open or close the hot keys help'

      # }, {
      #   keypress: 's',
      #   symbol:   's', # ←
      #   key_name: 'S key',
      #   action:   'Star current finding or highlight'
      # }, {
      #   keypress: 'shift+up',
      #   symbol:   '⇧ + ↑', # ←
      #   key_name: 'Shift + up arrow',
      #   action:   'Go to first finding or highlight'
      # }, {
      #   keypress: 'shift+down',
      #   symbol:   '⇧ + ↓', # ←
      #   key_name: 'Shift + down arrow',
      #   action:   'Go to last finding or highlight'
      }
    ]
  end
end
