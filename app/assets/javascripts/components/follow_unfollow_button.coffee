@FollowUnfollowButton = React.createClass
  propTypes:
    user:      React.PropTypes.object.isRequired,
    following: React.PropTypes.bool.isRequired

  getInitialState: ->
    following:  @props.following

  getLabel: -> if @state.following then 'Unfollow' else 'Follow'

  handleClick: (e) ->
    e.preventDefault()
    $.get @url(), success: (following) =>
      @setState(following: !@state.following)

  url: ->
    if @state.following
      "/unfollow/#{@props.user.id}"
    else
      "/follow/#{@props.user.id}"

  render: ->
    React.DOM.button
      className: 'btn btn-primary'
      onClick:   @handleClick
      @getLabel()