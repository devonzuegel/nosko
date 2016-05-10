@FindingCard = React.createClass
  # propTypes:
    # following:    React.PropTypes.bool.isRequired,
    # current_user: React.PropTypes.UserFacade,
    # user:         React.PropTypes.UserFacade,
    # followers:    React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  getInitialState: ->
    expanded: false

  ion_icon_link: (name, onclick, classes='') ->
    React.DOM.a className: "card-button #{classes}", onClick: onclick,
      React.DOM.div className: "ion-icon ion-#{name}"

  toggled_collapsed_class: ->
    if @state.expanded
      'expanded'
    else
      'collapsed'

  permalink_to_clipboard: ->
    alert("#{@props.article.href} has been copied to your clipboard!")
    Utils.copyToClipboard(@props.article.href)

  toggle_collapse: ->
    @setState
      expanded: !@state.expanded

  render: ->
    React.DOM.div className: 'card',
      React.DOM.div className: 'filled-div',
        React.DOM.a className: 'fill-div', href: @props.article.href
        React.DOM.div id: 'article-body', className: @toggled_collapsed_class(),
          React.DOM.h1 null, @props.article.title
          React.DOM.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }
      React.DOM.div className: 'card-buttons',
        React.DOM.div className: 'right',
          if @state.expanded
            @ion_icon_link('close', @toggle_collapse, 'smaller top-margin-tiny')
          else
            @ion_icon_link('more',  @toggle_collapse)
          @ion_icon_link('eye',   @permalink_to_clipboard)
          @ion_icon_link('link',  @permalink_to_clipboard)
        React.DOM.div className: 'left',
          React.DOM.div className: 'card-button',
            React.DOM.div className: 'date', "#{@props.article.updated_at} ago"