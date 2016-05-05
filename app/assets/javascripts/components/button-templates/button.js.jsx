var Button = React.createClass({
  propTypes: {
    handleClick:  React.PropTypes.func.isRequired,
    label:        React.PropTypes.string,
    classes:      React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      classes: 'btn'
    };
  },

  render: function () {
    return (
      <button className = { this.props.classes }
              onClick   = { this.props.handleClick }>{ this.props.label }</button>
    );
  }
});
