@UserSidebar = React.createClass
  propTypes:
    following:    React.PropTypes.bool.isRequired,
    current_user: React.PropTypes.UserFacade,
    user:         React.PropTypes.UserFacade,
    followers:    React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  getInitialState: ->
    following:  @props.following
    followers:  @props.followers

  update_followers: ->
    following = !@state.following
    followers = if following then @state.followers.concat([ @props.current_user ]) else @state.followers.filter ((f) -> f.id != @props.current_user.id).bind(this)
    @setState
      following: following
      followers: followers

  num_words: -> 111
  num_recs:  -> 222
  num_books: -> 333

  render: ->
    React.DOM.div null,
      if @props.user.id != @props.current_user.id
        React.createElement FollowUnfollowButton,
          user:         @props.user
          following:    @state.following
          propogation:  @update_followers
      React.DOM.div id: 'stats',
        React.DOM.p null, "#{@num_words()} words this week"
        React.DOM.p null, "#{@num_recs()} recommendations this month"
        React.DOM.p null, "#{@num_books()} books this year"
      React.createElement FollowersList,
        followers: @state.followers