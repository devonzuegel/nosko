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
    @setState
      following: !@state.following
      followers: @followers()

  followers: ->
    if !@state.following
      @state.followers.concat([ @props.current_user ])
    else
      @state.followers.filter ((f) -> f.id != @props.current_user.id).bind(this)

  num_words:     -> @props.user.num_words_this_week
  num_findings:  -> @props.user.num_findings_this_month
  num_books:     -> 333

  render: ->
    React.DOM.div null,
      if @props.user.id != @props.current_user.id
        React.createElement FollowUnfollowButton,
          user:         @props.user
          following:    @state.following
          propogation:  @update_followers
      React.DOM.table id: 'stats',
        React.DOM.tbody null,
          React.DOM.tr null,
            React.DOM.td className: 'ion-icon ion-bookmark'
            React.DOM.td null, "#{@num_words()} words this week"
          React.DOM.tr null,
            React.DOM.td className: 'ion-icon ion-ios-star'
            React.DOM.td null, "#{@num_findings()} findings this month"
          React.DOM.tr null,
            # React.DOM.td className: 'ion-icon ion-ios-book'
            # React.DOM.td null, "#{@num_books()} books this year"
      React.createElement FollowersList,
        followers: @state.followers