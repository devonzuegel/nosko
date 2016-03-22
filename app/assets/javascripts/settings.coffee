@Settings = React.createClass
  getInitialState: ->
    user: @props.user

  getDefaultProps: ->
    user: []

  # addFinding: (finding) ->
  #   findings = React.addons.update(@state.findings, { $push: [ finding ] })
  #   @setState findings: findings

  # deleteFinding: (finding) ->
  #   index = @state.findings.indexOf finding
  #   findings = React.addons.update(@state.findings, { $splice: [[ index, 1 ]] })
  #   @replaceState findings: findings

  # updateFinding: (finding, data) ->
  #   index = @state.findings.indexOf finding
  #   findings = React.addons.update(@state.findings, { $splice: [[ index, 1, data ]] })
  #   @replaceState findings: findings

  render: ->
    console.log @props.user
    React.DOM.div
      className: 'user-settings'
      React.DOM.hr null
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.tbody null,
          React.createElement SettingsField,
            key:   1
            name:  'Name'
            value: @props.user.name
          # for finding in @state.findings
          #   React.createElement Finding,
          #     key:                 finding.id
          #     finding:             finding
          #     handleDeleteFinding: @deleteFinding
          #     handleEditFinding:   @updateFinding
          #     kinds:               @props.kinds