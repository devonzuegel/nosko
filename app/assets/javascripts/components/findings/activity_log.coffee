@ActivityLog = React.createClass
  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired

  getInitialState: ->
    findings: @props.findings

  render: ->
    React.DOM.div className: 'activity-log',
      @state.findings.map (finding, id) =>
        React.DOM.li key:"#{id}", JSON.stringify(finding)