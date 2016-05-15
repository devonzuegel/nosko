@FindingsStream = React.createClass
  propTypes:
    articles: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade)

  getInitialState: ->
    active_finding_id: 0

  buttons: ->
    React.DOM.div className: 'btn-toolbar',
      React.DOM.div className: 'btn-group pull-right', role: 'group',
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('grid', null, 'Cards')
        React.DOM.button className: 'btn btn-secondary',
          Utils.ion_icon_link('navicon', null, 'Title Only')
        React.DOM.button
          className:      'btn btn-secondary'
          'data-toggle':  'modal'
          href:           '#hotkeys-modal'
          Utils.ion_icon_link('ios-help-outline', null, 'Hot keys')

  num_articles:               -> @props.articles.length
  is_selected:           (id) -> @state.active_finding_id == id
  finding_state_classes: (id) -> if @is_selected(id) then 'selected' else 'unselected'
  finding_id:            (id) -> "finding-#{id}"

  scroll_to: (finding_id) ->
    elem                  = document.getElementById(finding_id);
    elem.style.visibility = 'visible';
    elem.style.display    = 'block';
    elem.tabIndex         = '-1';
    elem.focus();

  findings: ->
    @props.articles.map (article, id) =>
      React.DOM.div id: @finding_id(id), className: @finding_state_classes(id), key: id,
        React.createElement FindingCard, article: article, selected: @is_selected(id)

  to_next_finding: ->
    if @state.active_finding_id < @num_articles() - 1
      @setState(active_finding_id: @state.active_finding_id + 1)
    @scroll_to(@finding_id(@state.active_finding_id))

  to_prev_finding: ->
    if @state.active_finding_id > 0
      @setState(active_finding_id: @state.active_finding_id - 1)
    @scroll_to(@state.active_finding_id)

  to_last_finding: ->
    @setState(active_finding_id: @num_articles() - 1)
    @scroll_to(@state.active_finding_id)

  to_first_finding: ->
    @setState(active_finding_id: 0)
    @scroll_to(@state.active_finding_id)

  hotkey_bindings: ->
    Mousetrap.bind 'down',        () => @to_next_finding()
    Mousetrap.bind 'up',          () => @to_prev_finding()
    Mousetrap.bind 'shift+down',  () => @to_last_finding()
    Mousetrap.bind 'shift+up',    () => @to_first_finding()

  render: ->
    @hotkey_bindings()
    React.DOM.div className: 'findings-stream',
      @buttons()
      @findings()
