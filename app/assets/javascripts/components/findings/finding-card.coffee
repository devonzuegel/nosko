@FindingCard = React.createClass
  propTypes:
    article:                React.PropTypes.ArticleFacade.isRequired
    selected:               React.PropTypes.bool.isRequired
    share_by_default_enums: React.PropTypes.arrayOf(React.PropTypes.string).isRequired

  componentDidMount: ->
    @setState
      overflowing:  @overflowing()
      visibility:   @props.article.visibility

  getInitialState: ->
    expanded:     false
    overflowing:  true
    locked:       @props.article.locked

  permalink_to_clipboard: ->
    alert("#{@props.article.href} has been copied to your clipboard!")
    Utils.copyToClipboard(@props.article.href)

  toggled_collapsed_class: ->   if @state.expanded then 'expanded' else 'collapsed'
  toggle_collapse:         ->   @setState(expanded: !@state.expanded)
  id:                      ->   "article-body-#{@props.article.to_param}"
  overflowing:             ->   document.getElementById( @id() ).offsetHeight >= 230

  toggle_lock: ->
    endpoint = if @state.locked then 'unlock' else 'lock'
    $.get "/finding/#{@props.article.to_param}/#{endpoint}", success: (res) =>
      @setState(locked: !@state.locked)

  resize_btn: ->
    if @state.overflowing
      icon_name = if @state.expanded then 'arrow-shrink' else 'arrow-resize'
      Utils.ion_icon_link(icon_name, @toggle_collapse, null, 'pull-right')

  lock_btn: ->
    if @state.locked
      Utils.ion_icon_link('android-lock', @toggle_lock, null, 'locked-btn-activated')
    else
      Utils.ion_icon_link('android-unlock', @toggle_lock)

  hotkey_bindings: ->
    return unless @props.selected
    Mousetrap.bind 'space', (e) =>
      e.preventDefault()
      @toggle_collapse()

  card_body: ->
    React.DOM.div className: 'filled-div',
      React.DOM.a className: 'fill-div', href: @props.article.href
      React.DOM.div id: @id(), className: "#{@toggled_collapsed_class()} article-body",
        React.DOM.h1 null, @props.article.title
        React.DOM.a href: @props.article.user.href,
          React.DOM.h4 className: 'above-card', @props.article.user.name
        React.DOM.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }

  update_visibility: (visibility) ->
    $.patch "/finding/#{@props.article.to_param}", { article: { visibility: visibility } }, (result) =>
      @setState(visibility: visibility)

  visibility_btn: ->
    id = "dropdown-#{@props.article.to_param}"
    React.DOM.div className: 'dropdown pull-right',
      React.DOM.a
        id:               id
        className:        'dropdown-toggle above-card'
        type:             'button'
        'aria-expanded':  'true'
        'aria-haspopup':  'true'
        'data-toggle':    'dropdown'
        Utils.ion_icon('eye', 'card-button')
      React.DOM.ul className: 'dropdown-menu centerDropdown', 'aria-labelledby': id,
        React.DOM.li className: 'dropdown-header', 'Change visibility'
        @props.share_by_default_enums.map (label, id) =>
          active_class = if label == @state.visibility then 'active' else 'inactive'
          update_visibility = => @update_visibility(label)
          React.DOM.li className: active_class, key: id,
            React.DOM.a href: '#', onClick: update_visibility, label

  card_buttons: ->
    React.DOM.div className: 'card-buttons',
      React.DOM.div className: 'right',
        @lock_btn()
        @visibility_btn()
        Utils.ion_icon_link('link', @permalink_to_clipboard)
      React.DOM.div className: 'left',
        React.DOM.div className: 'card-button',
          React.DOM.div className: 'date', "#{@props.article.updated_at} ago"

  render: ->
    @hotkey_bindings()

    React.DOM.div className: 'finding',
      React.DOM.div className: 'pull-right above-card', @resize_btn()
      @card_body()
      # @card_buttons()