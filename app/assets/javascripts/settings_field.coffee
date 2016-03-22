@SettingsField = React.createClass
  getInitialState: ->
    edit: false

  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.label
      React.DOM.td null,
        React.DOM.input
          className:     'form-control'
          type:          'text'
          defaultValue:  @props.value
          ref:           @props.ref
