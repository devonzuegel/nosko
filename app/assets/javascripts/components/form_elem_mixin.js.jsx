var FormElemMixin = {
  /* Create an initial state with the value passed to the input
   * or an empty value */
  getInitialState: function () {
    return {
      edited:       false,
      value:        this.props.value || '',
      serverErrors: null  // No initial server errors
    };
  },
  componentWillMount: function () {
    this.props.attachToForm(this); // Attaching the component to the form
  },
  componentWillUnmount: function () {
    this.props.detachFromForm(this); // Detaching if unmounting
  },

  // Whenever the input changes we update the value state of this component.
  setValue: function (event) {
    this.setState({
      value: event.currentTarget.value
    }, function () {
      // When the value changes, wait for it to propagate, then validate the input
      if (this.state.edited)    this.props.validate(this);
    }.bind(this));
  },

  onBlur: function (event) {
    this.props.validate(this);
    this.setState({ edited: true });
  }
};
