@FindingsStream = React.createClass
  propTypes:
    articles:                React.PropTypes.arrayOf(React.PropTypes.ArticleFacade)
    share_by_default_enums:  React.PropTypes.arrayOf(React.PropTypes.string).isRequired

  getInitialState: ->
    active_finding_id: 0

  buttons: ->
    React.DOM.div className: 'btn-toolbar',
      React.DOM.div className: 'btn-group pull-right', role: 'group',
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('android-funnel', null, 'Filter')
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('grid', null, 'Cards')
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('navicon', null, 'Title Only')
        React.DOM.button
          className:      'btn btn-secondary'
          'data-toggle':  'modal'
          href:           @modal_id()
          Utils.ion_icon_link('ios-help-outline', null, 'Hot keys')

  num_articles:               -> @props.articles.length
  is_selected:           (id) -> @state.active_finding_id == id
  finding_state_classes: (id) -> if @is_selected(id) then 'selected' else 'unselected'
  finding_id:            (id) -> "finding-#{id}"
  modal_id:                   -> '#hotkeys-modal'

  scroll_to: (finding_id) ->
    return if $("##{finding_id}").is_fully_in_view()
    document.getElementById(finding_id).scrollIntoView(true)

  findings: ->
    @props.articles.map (article, id) =>
      React.DOM.div id: @finding_id(id), className: @finding_state_classes(id), key: id,
        React.createElement FindingCard, article: article, selected: @is_selected(id), share_by_default_enums: @props.share_by_default_enums

  to_next_finding: (e) ->
    e.preventDefault()
    if @state.active_finding_id < @num_articles() - 1
      @setState(active_finding_id: @state.active_finding_id + 1)
    @scroll_to(@finding_id(@state.active_finding_id))

  to_prev_finding: (e) ->
    e.preventDefault()
    if @state.active_finding_id > 0
      @setState(active_finding_id: @state.active_finding_id - 1)
    @scroll_to(@finding_id(@state.active_finding_id))

  to_last_finding: (e) ->
    e.preventDefault()
    @setState(active_finding_id: @num_articles() - 1)
    @scroll_to(@finding_id(@state.active_finding_id))

  to_first_finding: (e) ->
    e.preventDefault()
    @setState(active_finding_id: 0)
    @scroll_to(@finding_id(@state.active_finding_id))

  open_hotkeys_help: (e) ->
    e.preventDefault()
    $( @modal_id() ).modal('toggle');

  hotkey_bindings: ->
    Mousetrap.bind 'h',           (e) => @open_hotkeys_help(e)
    Mousetrap.bind 'down',        (e) => @to_next_finding(e)
    Mousetrap.bind 'up',          (e) => @to_prev_finding(e)
    Mousetrap.bind 'shift+down',  (e) => @to_last_finding(e)
    Mousetrap.bind 'shift+up',    (e) => @to_first_finding(e)

  render: ->
    @hotkey_bindings()
    React.DOM.div null,
      React.DOM.div className: 'findings-stream',
        @buttons()
        @findings()
