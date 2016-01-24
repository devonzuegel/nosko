@FindingForm = React.createClass
  getInitialState: ->
    title: ''
    url: 'http://'
    kind: ''

  handleSubmit: (e) ->
    e.preventDefault()
    $.post 'findings', { finding: @state }, (data) =>
      @props.handleNewFinding data
      @setState @getInitialState()
    , 'JSON'

  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'URL'
          name: 'url'
          value: @state.url
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Title'
          name: 'title'
          value: @state.title
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Kind'
          name: 'kind'
          value: @state.kind
          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Create finding!'

  valid: ->
    @state.url && @state.title && @state.kind

  handleChange: (e) ->
    name = e.target.name
    @setState "#{name}": e.target.value