TransitionGroup = React.addons.CSSTransitionGroup

@ActivityLog = React.createClass
  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired

  getInitialState: ->
    findings: @props.findings
  render: ->
    React.DOM.div id: 'activity-log', className: 'list-group',
      React.createElement TransitionGroup, transitionName: 'example', transitionEnterTimeout: 400, transitionLeaveTimeout: 400,
        @state.findings.map (finding, id) =>
          class_active = if id==1 then 'active' else 'inactive'
          React.DOM.button
            type: 'button'
            key: id
            id: "list-group-item-#{id}"
            className: "list-group-item #{class_active}"
            finding.title

            React.DOM.span className: 'pull-right badge', finding.visibility