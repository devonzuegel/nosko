@UserStats = React.createClass
  propTypes:
    user:         React.PropTypes.object.isRequired,
    followers:    React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    current_user: React.PropTypes.object.isRequired,
    following:    React.PropTypes.bool.isRequired

  getInitialState: ->
    following:  @props.following

  update_followers: ->
    alert()

  getNumWords: -> 111
  getNumRecs:  -> 222
  getNumBooks: -> 333

  render: ->
    console.log @props.followers
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