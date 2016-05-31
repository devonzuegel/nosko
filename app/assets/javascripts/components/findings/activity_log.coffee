TransitionGroup = React.addons.CSSTransitionGroup
R               = React.DOM

@ActivityLog = React.createClass
  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired
    # TODO need to actually persist the reviewing

  getInitialState: ->
    findings: @props.findings

  rendered_findings: ->
    @state.findings.map (finding, id) =>
      R.button
        type:       'button'
        onClick:    @handleRemove.bind(this, id)
        key:        finding.title
        id:         "list-group-item-#{id}"
        className:  'list-group-item'

        finding.title
        R.span className: 'pull-right badge', finding.visibility

  rand_str: -> Math.random().toString(36).substring(7)

  handleAdd: ->
    new_findings = @state.findings.concat([{ title: @rand_str() }])
    @setState findings: new_findings

  handleRemove: (i) ->
    new_findings = @state.findings.slice()
    new_findings.splice(i, 1)
    @setState findings: new_findings

  render: ->
    R.div id: 'activity-log', className: 'list-group',
      R.button onClick: @handleAdd, 'Add Item'
      React.createElement TransitionGroup,
        transitionName:          'slide'
        transitionEnterTimeout:   0
        transitionLeaveTimeout:  300
        @rendered_findings()