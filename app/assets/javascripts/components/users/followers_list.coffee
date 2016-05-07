@FollowersList = React.createClass
  propTypes:
    followers: React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  render: ->
    React.DOM.div id: 'followers-sidebar',
      React.DOM.h3 null, 'Followers'
      React.DOM.ul null,
        @props.followers.map (f) ->
          React.DOM.li key: f.id,
            React.DOM.a href: f.href, f.name
