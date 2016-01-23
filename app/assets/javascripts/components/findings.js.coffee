@Findings = React.createClass
  getInitialState: ->
    console.log @props.data
    findings: @props.data

  getDefaultProps: ->
    findings: []

  render: ->
    React.DOM.div
      className: 'findings'
      React.DOM.h2
        className: 'title'
        'Findings'
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Title'
            React.DOM.th null, 'Amount'
        React.DOM.tbody null,
          for finding in @state.findings
            React.createElement Finding, key: finding.id, finding: finding
