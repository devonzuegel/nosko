@FindingForm = React.createClass
  getInitialState: ->
    title: ''
    url:   ''
    kind:  ''

  handleSubmit: (e) ->
    e.preventDefault()
    $.post 'findings', { finding: @state }, (data) =>
      @props.handleNewFinding data
      @setState @getInitialState()
    , 'JSON'

  render: ->
    React.DOM.form
      className:   'form-inline'
      onSubmit:    @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type:        'text'
          className:   'form-control'
          placeholder: 'URL'
          name:        'url'
          value:       @state.url
          onChange:    @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type:        'text'
          className:   'form-control'
          placeholder: 'Title'
          name:        'title'
          value:       @state.title
          onChange:    @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.select
          className:    'form-control'
          name:         'kind'
          value:        'Other'
          defaultValue: 'Other'
          value:        @state.kind
          onChange:     @handleChange
          for kind in @props.kinds
            React.DOM.option value: kind, kind
      React.DOM.button
        type:      'submit'
        className: 'btn btn-primary'
        disabled:  !@valid()
        'Create finding!'

  valid: ->
    @state.url && @state.title && @state.kind && validURL(@state.url)

  handleChange: (e) ->
    name = e.target.name
    @setState "#{name}": e.target.value