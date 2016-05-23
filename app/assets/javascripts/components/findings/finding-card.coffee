@FindingCard = React.createClass
  propTypes:
    article:  React.PropTypes.ArticleFacade.isRequired
    selected: React.PropTypes.bool.isRequired

  componentDidMount: ->
    @setState
      overflowing:  @overflowing()

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

  toggle_lock:             ->
    endpoint = if @state.locked then 'unlock' else 'lock'
    $.get "/finding/#{@props.article.to_param}/#{endpoint}", success: (res) =>
      @setState(locked: !@state.locked)
      Utils.puts res

  resize_btn: ->
    if @state.overflowing
      icon_name = if @state.expanded then 'arrow-shrink' else 'arrow-resize'
      Utils.ion_icon_link(icon_name, @toggle_collapse)

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
        React.DOM.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }

  update_visibility: ->
    data =
      article:
        visibility: 'Public'

    $.patch "/finding/#{@props.article.to_param}", data, (result) ->
      Utils.puts result

  card_buttons: ->
    React.DOM.div className: 'card-buttons',
      React.DOM.div className: 'right',
        @lock_btn()
        Utils.ion_icon_link('eye',  @update_visibility)
        Utils.ion_icon_link('link', @permalink_to_clipboard)
      React.DOM.div className: 'left',
        React.DOM.div className: 'card-button',
          React.DOM.div className: 'date', "#{@props.article.updated_at} ago"

  render: ->
    @hotkey_bindings()
    React.DOM.div className: 'card',
      React.DOM.div className: 'pull-right top', @resize_btn()
      @card_body()
      @card_buttons()