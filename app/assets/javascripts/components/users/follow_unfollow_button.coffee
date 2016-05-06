@FollowUnfollowButton = React.createClass
  propTypes:
    following:    React.PropTypes.bool.isRequired,
    propogation:  React.PropTypes.func,
    user:         React.PropTypes.shape({
      id: React.PropTypes.number.isRequired,
    }).isRequired

  getInitialState: ->
    following:  @props.following

  getLabel: -> if @state.following then 'Unfollow' else 'Follow'

  handleClick: (e) ->
    e.preventDefault()
    if @props.propogation then @props.propogation()
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