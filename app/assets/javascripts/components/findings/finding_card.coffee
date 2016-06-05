R = React.DOM

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

  label_class: ->
    switch @state.visibility
      when 'Only me' then 'label-primary'
      when 'Friends' then 'label-info'
      when 'Public'  then 'label-success'
      else                'label-default'

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
      toggleBtn:           =>
        R.span
          className: "label #{@label_class()} pull-right card-button"
          @state.visibility

  card_buttons: ->
    R.div className: 'card-buttons above-card',
      R.div className: 'right',
        if @props.article.editable  # Only editable if owned by current user
          R.div null,
            @visibility_btn()
            @lock_btn()
        Utils.ion_icon_link('link', @permalink_to_clipboard)
        @resize_btn()

  render: ->
    @hotkey_bindings()
    R.div className: 'finding',
      R.div className: 'filled-div',
        R.a className: 'fill-div', href: @props.article.href
        R.div id: @id(), className: "#{@toggled_collapsed_class()} article-body",
          R.h2 null, @props.article.title
          R.div className: 'date-and-user',
            R.a className: 'user-link', href: @props.article.user.href,
              R.div className: 'above-card', @props.article.user.name
            R.div className: 'date-and-user-spacer', '//'
            R.div className: 'date ', @props.article.created_at
          if !@props.title_only
            R.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }
        @card_buttons() if @props.selected