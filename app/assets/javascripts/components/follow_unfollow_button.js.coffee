@FollowUnfollowButton = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  handleClick: (e) ->
    e.preventDefault()
    $.get @url(), (data) -> console.log data

  url: -> '/follow/' + @props.user.id

  render: ->
    React.createElement Button,
      handleClick:  @handleClick
      classes:      'btn btn-primary'
      label:        'Follow'