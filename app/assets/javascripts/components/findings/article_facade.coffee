React.PropTypes.ArticleFacade = React.PropTypes.shape({
  content:      React.PropTypes.string.isRequired,
  href:         React.PropTypes.string.isRequired,
  source_url:   React.PropTypes.string,
  title:        React.PropTypes.string.isRequired,
  to_param:     React.PropTypes.string.isRequired,
  updated_at:   React.PropTypes.string.isRequired
}).isRequired