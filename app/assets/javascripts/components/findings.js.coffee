@Findings = React.createClass
  getInitialState: ->
    findings: @props.findings

  getDefaultProps: ->
    findings: []

  addFinding: (finding) ->
    findings = @state.findings.slice()
    findings.push finding
    @setState findings: findings

  deleteFinding: (finding) ->
    findings = @state.findings.slice()
    index = findings.indexOf finding
    findings.splice index, 1
    @replaceState findings: findings

  render: ->
    React.DOM.div
      className: 'findings'
      React.createElement FindingForm, handleNewFinding: @addFinding, kinds: @props.kinds
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Title'
            React.DOM.th null, 'Type'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for finding in @state.findings
            React.createElement Finding,
              key:                 finding.id
              finding:             finding
              handleDeleteFinding: @deleteFinding
