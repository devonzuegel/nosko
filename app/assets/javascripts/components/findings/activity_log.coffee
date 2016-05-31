TransitionGroup = React.addons.CSSTransitionGroup

@ActivityLog = React.createClass
  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired
    # TODO need to actually persist the reviewing

  getInitialState: ->
    findings: @props.findings

  rendered_findings: ->
    @state.findings.map (finding, id) =>
      class_active = ''# if id==1 then 'active' else 'inactive'
      React.DOM.button
        type: 'button'
        onClick: @handleRemove.bind(this, id)
        key: id
        id: "list-group-item-#{id}"
        className: "list-group-item #{class_active} slide-out"
        finding.title
        React.DOM.span className: 'pull-right badge', finding.visibility

  handleAdd: ->
    new_findings = @state.findings.concat([{ title: 'BLAH' }])
    @setState findings: new_findings

  handleRemove: (i) ->
    new_findings = @state.findings.slice()
    new_findings.splice(i, 1)
    @setState findings: new_findings

  render: ->
    React.DOM.div id: 'activity-log', className: 'list-group',
      React.DOM.button onClick: @handleAdd, 'Add Item'
      React.createElement TransitionGroup,
        transitionName:          'example'
        transitionEnterTimeout:  500
        transitionLeaveTimeout:  300
        @rendered_findings()