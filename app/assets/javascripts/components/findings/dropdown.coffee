@Dropdown = React.createClass
  propTypes:
    button:           React.PropTypes.func.isRequired
    id:               React.PropTypes.string.isRequired
    onItemClick:      React.PropTypes.func.isRequired
    option_labels:    React.PropTypes.arrayOf(React.PropTypes.string).isRequired
    active_label:     React.PropTypes.string
    header:           React.PropTypes.string
    dropdownClasses:  React.PropTypes.string
    toggleBtnClasses: React.PropTypes.string
    menuClasses:      React.PropTypes.string

  render: ->
    React.DOM.div className: "dropdown #{@props.dropdownClasses}",
      React.DOM.a
        id:               @props.id
        className:        "dropdown-toggle above-card #{@props.toggleBtnClasses}"
        type:             'button'
        'aria-expanded':  'true'
        'aria-haspopup':  'true'
        'data-toggle':    'dropdown'
        @props.button()
      React.DOM.ul className: "dropdown-menu #{@props.menuClasses}", 'aria-labelledby': @props.id,
        if @props.header
          React.DOM.li className: 'dropdown-header', @props.header
        @props.option_labels.map (label, i) =>
          active_class = if label == @props.active_label then 'active' else 'inactive'
          update_visibility = => @props.onItemClick(label)
          React.DOM.li className: active_class, key: i,
            React.DOM.a href: '#', onClick: update_visibility, label