@Findings = React.createClass
  getInitialState: ->
    findings: @props.findings

  getDefaultProps: ->
    findings: []

  addFinding: (finding) ->
    findings = React.addons.update(@state.findings, { $push: [ finding ] })
    @setState findings: findings

  deleteFinding: (finding) ->
    index = @state.findings.indexOf finding
    findings = React.addons.update(@state.findings, { $splice: [[ index, 1 ]] })
    @replaceState findings: findings

  updateFinding: (finding, data) ->
    index = @state.findings.indexOf finding
    findings = React.addons.update(@state.findings, { $splice: [[ index, 1, data ]] })
    @replaceState findings: findings

  render: ->
    React.DOM.div
      className: 'findings'
      # React.createElement FindingForm, handleNewFinding: @addFinding, kinds: @props.kinds
      React.createElement NewFindingForm, handleNewFinding: @addFinding, kinds: @props.kinds
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            for label, i in [ 'Date', 'Title', 'Type', 'Actions' ]
              React.DOM.th key: i, label
        React.DOM.tbody null,
          for finding in @state.findings
            React.createElement Finding,
              key:                 finding.id
              finding:             finding
              handleDeleteFinding: @deleteFinding
              handleEditFinding:   @updateFinding
