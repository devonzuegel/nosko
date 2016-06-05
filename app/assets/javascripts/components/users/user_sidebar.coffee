R = React.DOM

@UserSidebar = React.createClass
  propTypes:
    following:       React.PropTypes.bool.isRequired,
    friends_with:    React.PropTypes.bool.isRequired,
    request_pending: React.PropTypes.bool.isRequired,
    current_user:    React.PropTypes.UserFacade,
    user:            React.PropTypes.UserFacade,
    followers:       React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  getInitialState: ->
    following:       @props.following
    friends_with:    @props.friends_with
    request_pending: @props.request_pending
    followers:       @props.followers

  update_followers: ->
    @setState
      following: !@state.following
      followers: @followers()

  followers: ->
    if !@followable()
      @state.followers
    else if !@state.following
      @state.followers.concat([ @props.current_user ])
    else
      @state.followers.filter ((f) -> f.id != @props.current_user.id).bind(this)

  num_words:     -> @props.user.num_words_this_week
  num_findings:  -> @props.user.num_findings_this_month
  num_books:     -> 333
  followable:    -> (@props.current_user != null) && (@props.user.id != @props.current_user.id)
  follow:        ->
    return if @state.following
    $.get "/follow/#{@props.user.id}", success: =>
      @update_followers()

  render: ->
    React.DOM.div null,
      if @followable()
        R.table null, R.tbody null,
          R.tr null,
            R.td null,
              React.createElement FollowUnfollowButton,
                user:         @props.user
                following:    @state.following
                propogation:  @update_followers
            R.td null,
              React.createElement FriendUnfriendButton,
                user:            @props.user
                friends_with:    @state.friends_with
                request_pending: @state.request_pending
                propogation:     @follow
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