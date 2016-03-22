@SettingsField = React.createClass
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
      React.DOM.td null, @props.name
      React.DOM.td null, @props.value
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Edit'

  editFinding: ->
    React.DOM.tr null,
      React.DOM.td null, @props.name
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.value
          ref: 'title'
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleEdit
          'Update'

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
    # console.log @props.finding
    $.ajax  # jQuery doesn't have a $.delete shortcut method
      method: 'DELETE'
      url: "/findings/#{ @props.finding.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteFinding @props.finding
