@FindingCard = React.createClass
  propTypes:
    article:                React.PropTypes.ArticleFacade.isRequired
    selected:               React.PropTypes.bool.isRequired
    share_by_default_enums: React.PropTypes.arrayOf(React.PropTypes.string).isRequired
    title_only:             React.PropTypes.bool

  getDefaultProps: ->
    title_only: false

  componentDidMount: ->
    @setState
      overflowing:  @overflowing()

  getInitialState: ->
    visibility:   @props.article.visibility
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
        React.DOM.div className: 'date-and-user',
          React.DOM.a className: 'user-link', href: @props.article.user.href,
            React.DOM.div className: 'above-card', @props.article.user.name
          React.DOM.div className: 'date-and-user-spacer', '//'
          React.DOM.div className: 'date ', @props.article.created_at
        if !@props.title_only
          React.DOM.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }
      @card_buttons() if @props.selected

  update_visibility: (visibility) ->
    data = { article: { visibility: visibility } }
    $.patch "/finding/#{@props.article.to_param}", data, (result) =>
      @setState(visibility: visibility)

  visibility_btn: ->
    React.createElement Dropdown,
      id:                  "dropdown-#{@props.article.to_param}"
      header:              'Change visibility'
      option_labels:       @props.share_by_default_enums
      active_label:        @state.visibility
      dropdownClasses:     'pull-right'
      menuClasses:         'centerDropdown'
      onItemClick: (label) => @update_visibility(label)
      button:              =>
        icon =  if @state.visibility == 'Only me' then 'eye-disabled' else 'eye'
        Utils.ion_icon(icon, 'card-button')

  card_buttons: ->
    React.DOM.div className: 'card-buttons above-card',
      React.DOM.div className: 'right',
        if @props.article.editable  # Only editable if owned by current user
          React.DOM.div null,
            @lock_btn()
            @visibility_btn()
        Utils.ion_icon_link('link', @permalink_to_clipboard)
        @resize_btn()

  render: ->
    @hotkey_bindings()

    React.DOM.div className: 'finding',
      @card_body()