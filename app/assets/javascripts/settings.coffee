@Settings = React.createClass
  getInitialState: ->
    user: @props.user

  propTypes:
    user: React.PropTypes.object.isRequired

  handleUpdate: ->
    console.log 'TODO: write handleUpdate()'

  render: ->
    React.DOM.div
      className: 'findings'
      React.createElement SettingsForm, handleUpdate: @handleUpdate, user: @state.user
  # render: ->
  #   console.log @state.user
  #   React.DOM.div
  #     className: 'user-settings'
  #     React.DOM.hr null
  #     React.DOM.table
  #       className: 'table table-bordered'
  #       React.DOM.tbody null,
  #         React.createElement SettingsField,
  #           key:   1
  #           label: 'Name'
  #           ref:   'name'
  #           value: @props.user.name
  #         # for finding in @state.findings
  #         #   React.createElement Finding,
  #         #     key:                 finding.id
  #         #     finding:             finding
  #         #     handleDeleteFinding: @deleteFinding
  #         #     handleEditFinding:   @updateFinding
  #         #     kinds:               @props.kinds
  #     React.DOM.a
  #       className: 'btn btn-default'
  #       onClick: @handleEdit
  #       'Save changes'

  # handleEdit: (e) ->
  #   e.preventDefault()
  #   console.log ReactDOM.findDOMNode(@refs.name).value
  #   console.log ReactDOM.findDOMNode(@refs.name).val
  #   data =
  #     name: @refs.name.getDOMNode.value || 'blahhhhhh'
  #   console.log 'data:'
  #   console.log data
  #   $.ajax  # jQuery doesn't have a $.put shortcut method
  #     method: 'PUT'
  #     url: "/users/#{ @props.user.id }"
  #     dataType: 'JSON'
  #     data:
  #       user: data
  #     success: (data) =>
  #       @setState edit: false
  #       alert 'Saved successfully!'