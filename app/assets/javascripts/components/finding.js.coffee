@Finding = React.createClass
  render: ->
    React.DOM.tr null,
      React.DOM.td null, moment( @props.finding.created_at ).fromNow()
      React.DOM.td null, @props.finding.title
      React.DOM.td null, @props.finding.kind
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'

  handleDelete: (e) ->
    e.preventDefault()
    console.log @props.finding
    $.ajax  # jQuery doesn't have a $.delete shortcut method
      method: 'DELETE'
      url: "/findings/#{ @props.finding.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteFinding @props.finding
