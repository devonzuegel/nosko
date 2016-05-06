@FollowersList = React.createClass
  propTypes:
    followers: React.PropTypes.arrayOf(React.PropTypes.UserFacade).isRequired

  render: ->
    React.DOM.div null,
      React.DOM.h3 null,
        'Followers'
      React.DOM.ul null,
        @props.followers.map, (f) ->
          React.DOM.a
            key:   f.id
            href:  f.href
            f.name