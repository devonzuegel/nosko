@FriendUnfriendButton = React.createClass
  propTypes:
    friends_with:    React.PropTypes.bool.isRequired,
    request_pending: React.PropTypes.bool.isRequired,
    propogation:     React.PropTypes.func.isRequired,
    user:            React.PropTypes.UserFacade

  getInitialState: ->
    friends_with:     @props.friends_with
    request_pending:  @props.request_pending

  getLabel: ->
    if @state.friends_with
      'Unfriend'
    else if @state.request_pending
      'Request pending'
    else
      'Friend'

  handleClick: (e) ->
    e.preventDefault()
    return if @state.request_pending
    $.get @url(), success: =>
      if @state.friends_with
        @setState(friends_with: false)
      else
        @setState(request_pending: true)
        @props.propogation()

  url: ->
    if @state.friends_with
      "/unfriend/#{@props.user.id}"
    else if !@state.request_pending
      "/friend/#{@props.user.id}"

  render: ->
    if @state.request_pending
      klass = 'disabled'
    React.DOM.button
      className: "btn btn-primary #{klass}"
      onClick:   @handleClick
      @getLabel()