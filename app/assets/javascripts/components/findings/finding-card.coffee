@FindingCard = React.createClass
  propTypes:
    article: React.PropTypes.ArticleFacade

  componentDidMount: ->
    @setState
      overflowing:  @overflowing()

  getInitialState: ->
    expanded:     false
    overflowing:  true
    locked:       @props.article.locked

  ion_icon_link: (name, onclick, classes='') ->
    React.DOM.a className: "card-button #{classes}", onClick: onclick,
      React.DOM.div className: "ion-icon ion-#{name}"

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
      @ion_icon_link(icon_name,  @toggle_collapse)

  lock_btn: ->
    if @state.locked
      @ion_icon_link('android-lock', @toggle_lock, 'locked-btn-activated')
    else
      @ion_icon_link('android-unlock', @toggle_lock)

  render: ->
    React.DOM.div className: 'card',
      React.DOM.div className: 'pull-right top', @resize_btn()
      React.DOM.div className: 'filled-div',
        React.DOM.a className: 'fill-div', href: @props.article.href
        React.DOM.div id: @id(), className: "#{@toggled_collapsed_class()} article-body",
          React.DOM.h1 null, @props.article.title
          React.DOM.div className: 'markdown-body', dangerouslySetInnerHTML: { __html: @props.article.content }
      React.DOM.div className: 'card-buttons',
        React.DOM.div className: 'right',
          @lock_btn()
          @ion_icon_link('eye',  @overflow_test)
          @ion_icon_link('link', @permalink_to_clipboard)
        React.DOM.div className: 'left',
          React.DOM.div className: 'card-button',
            React.DOM.div className: 'date', "#{@props.article.updated_at} ago"
            # React.DOM.div null, "locked = #{@state.locked}"