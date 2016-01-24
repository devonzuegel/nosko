var Input = React.createClass({

  // Create an initial state with the value passed to the input
  // or an empty value
  getInitialState: function () {
    return {
      value: this.props.value || ''
    };
  },
  componentWillMount: function () {
    this.props.attachToForm(this); // Attaching the component to the form
  },
  componentWillUnmount: function () {
    this.props.detachFromForm(this); // Detaching if unmounting
  },

  // Whenever the input changes we update the value state
  // of this component
  setValue: function (event) {
    this.setState({
      value: event.currentTarget.value
    }, function () {
      // When the value changes, wait for it to propagate, then validate the input
      this.props.validate(this);
    }.bind(this));
  },
  render: function () {
    return (
      <input type="text" name={this.props.name} onChange={this.setValue} value={this.state.value}/>
    );
  }
});
