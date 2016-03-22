@Finding = React.createClass
  getInitialState: ->
    edit: false

  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit

  render: ->
    if @state.edit
      @editFinding()
    else
      @readOnly()

  readOnly: ->
    React.DOM.tr null,
      React.DOM.td null, moment( @props.finding.created_at ).fromNow()
      React.DOM.td null,
        React.DOM.a
          href: "http://#{@props.finding.url}"
          @props.finding.title
      React.DOM.td null, @props.finding.kind
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Edit'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'

  editFinding: ->
    React.DOM.tr null,
      React.DOM.td null, moment( @props.finding.created_at ).fromNow()
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.finding.title
          ref: 'title'
      React.DOM.td null,
        React.DOM.select
          className: 'form-control'
          defaultValue: @props.finding.kind
          ref: 'kind'
          @props.kinds.map (opt, i) ->
            React.DOM.option
              value: opt
              key: i
              opt
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleEdit
          'Update'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleToggle
          'Cancel'

  handleEdit: (e) ->
    e.preventDefault()
    data =
      title: React.findDOMNode(@refs.title).value
      kind:  React.findDOMNode(@refs.kind).value
    $.ajax  # jQuery doesn't have a $.put shortcut method
      method: 'PUT'
      url: "/findings/#{ @props.finding.id }"
      dataType: 'JSON'
      data:
        finding: data
      success: (data) =>
        @setState edit: false
        @props.handleEditFinding @props.finding, data

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax  # jQuery doesn't have a $.delete shortcut method
      method: 'DELETE'
      url: "/findings/#{ @props.finding.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteFinding @props.finding
