@UserStats = React.createClass
  propTypes:
    following:    React.PropTypes.bool.isRequired,
    current_user: React.PropTypes.UserFacade,
    user:         React.PropTypes.UserFacade,
    followers:    React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  getInitialState: ->
    following:  @props.following
    followers:  @props.followers

  update_followers: ->
    alert()

  getNumWords: -> 111
  getNumRecs:  -> 222
  getNumBooks: -> 333

  render: ->
    console.log @props.followers
    console.log @props.current_user
    console.log @props.user
    React.DOM.div null,
      if @props.user.id != @props.current_user.id
        React.createElement FollowUnfollowButton,
          user:         @props.user
          following:    @state.following
          propogation:  @update_followers
      React.DOM.div id: 'stats',
        React.DOM.p null, "#{@getNumWords()} words this week"
        React.DOM.p null, "#{@getNumRecs()} recommendations this month"
        React.DOM.p null, "#{@getNumBooks()} books this year"
      React.createElement FollowersList,
        followers: @state.followers