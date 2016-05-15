@FindingsStream = React.createClass
  propTypes:
    articles: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade)

  getInitialState: ->
    active_finding_id: 0

  num_articles: -> @props.articles.length

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

  finding_state_classes: (id) ->
    if (@state.active_finding_id == id) then 'selected' else 'unselected'

  findings: ->
    finding_state_classes = @finding_state_classes
    @props.articles.map (article, i) ->
      React.DOM.div id: "finding-#{i}", className: finding_state_classes(i), key: i,
        React.createElement FindingCard, article: article

  to_next_finding: ->
    if @state.active_finding_id < @num_articles() - 1
      @setState(active_finding_id: @state.active_finding_id + 1)

  to_prev_finding: ->
    if @state.active_finding_id > 0
      @setState(active_finding_id: @state.active_finding_id - 1)

  to_last_finding: ->
    @setState(active_finding_id: @num_articles() - 1)

  to_first_finding: ->
    @setState(active_finding_id: 0)

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
