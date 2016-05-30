React.PropTypes.ArticleFacade = React.PropTypes.shape({
  title:        React.PropTypes.string.isRequired,
  content:      React.PropTypes.string.isRequired,
  source_url:   React.PropTypes.string,
  href:         React.PropTypes.string.isRequired,
  locked:       React.PropTypes.bool.isRequired,
  to_param:     React.PropTypes.string.isRequired,
  editable:     React.PropTypes.bool.isRequired,
  visibility:   React.PropTypes.string.isRequired,
  updated_at:   React.PropTypes.string.isRequired,
})