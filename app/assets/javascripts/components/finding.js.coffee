@Finding = React.createClass
  render: ->
    React.DOM.tr null,
      created_at = @props.finding.created_at
      React.DOM.td null, moment(created_at).fromNow()
      React.DOM.td null, @props.finding.title
      React.DOM.td null, amountFormat(333)
