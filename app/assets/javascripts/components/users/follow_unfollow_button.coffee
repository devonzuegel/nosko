@FollowUnfollowButton = React.createClass
  propTypes:
    following:    React.PropTypes.bool.isRequired,
    user:         React.PropTypes.UserFacade,
    propogation:  React.PropTypes.func

  getLabel: -> if @props.following then 'Unfollow' else 'Follow'

  handleClick: (e) ->
    e.preventDefault()
    $.get @url(), success: =>
      if @props.propogation then @props.propogation()

  url: ->
    if @props.following
      "/unfollow/#{@props.user.id}"
    else
      "/follow/#{@props.user.id}"

  render: ->
    React.DOM.button
      className: 'btn btn-primary'
      onClick:   @handleClick
      @getLabel()