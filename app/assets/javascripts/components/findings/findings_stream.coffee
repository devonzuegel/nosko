@FindingsStream = React.createClass
  mixins: [HotkeysModal]

  propTypes:
    articles:                React.PropTypes.arrayOf(React.PropTypes.ArticleFacade)
    share_by_default_enums:  React.PropTypes.arrayOf(React.PropTypes.string).isRequired

  getInitialState:            -> active_id: 0
  num_articles:               -> @props.articles.length
  is_selected:           (id) -> @state.active_id == id
  finding_state_classes: (id) -> if @is_selected(id) then 'selected' else 'unselected'
  finding_id:            (id) -> "finding-#{id}"

  buttons: ->
    React.DOM.div className: 'btn-toolbar',
      React.DOM.div className: 'btn-group pull-right', role: 'group',
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('android-funnel', null, 'Filter')
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('grid', null, 'Cards')
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('navicon', null, 'Title Only')
        @hotkeys_modal_btn()

  findings: ->
    @props.articles.map (article, id) =>
      React.DOM.div id: @finding_id(id), className: @finding_state_classes(id), key: id,
        React.createElement FindingCard, article: article, selected: @is_selected(id), share_by_default_enums: @props.share_by_default_enums

  to_next_finding: (e) ->
    e.preventDefault()
    if @state.active_id < @num_articles() - 1
      @setState(active_id: @state.active_id + 1)
    Utils.scroll_to(@finding_id(@state.active_id))

  to_prev_finding: (e) ->
    e.preventDefault()
    if @state.active_id > 0
      @setState(active_id: @state.active_id - 1)
    Utils.scroll_to(@finding_id(@state.active_id))

  to_last_finding: (e) ->
    e.preventDefault()
    @setState(active_id: @num_articles() - 1)
    Utils.scroll_to(@finding_id(@state.active_id))

  to_first_finding: (e) ->
    e.preventDefault()
    @setState(active_id: 0)
    Utils.scroll_to(@finding_id(@state.active_id))

  hotkey_bindings: ->
    Mousetrap.bind 'down',        (e) => @to_next_finding(e)
    Mousetrap.bind 'up',          (e) => @to_prev_finding(e)
    Mousetrap.bind 'ctrl+down',   (e) => @to_last_finding(e)
    Mousetrap.bind 'ctrl+up',     (e) => @to_first_finding(e)

  render: ->
    @hotkey_bindings()
    React.DOM.div null,
      React.DOM.div className: 'findings-stream',
        @buttons()
        @findings()
