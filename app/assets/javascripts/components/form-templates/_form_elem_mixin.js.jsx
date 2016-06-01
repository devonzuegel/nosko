var FormElemMixin = {
  getInitialState: function () {
    var defaultVal = (this.getDefaultValue != null) ? this.getDefaultValue() : null;
    return {
      edited:       false,
      isValid:      false,
      value:        defaultVal || this.props.value || '',
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
    // When the value changes, wait for it to propagate, then validate the input
    this.setState({ value: event.currentTarget.value }, function () {
      this.props.validate(this);
    }.bind(this));
  },

  onBlur: function (event) {
    this.props.validate(this);
    this.setState({ edited: true });
  },

  getClassName: function () {
    var str = this.state.isValid ? '' : 'error ';
    return str + this.props.className
  },

  getValidations: function () {
    var validations = this.props.validations;
    if (this.props.required == true)  validations.push({ fn: Utils.required });
    return validations;
  },

  getErrors: function () {
    if (this.state.isValid)   return null;
    return this.state.serverErrors || this.state.validationError;
    // Prioritize marking it as required over marking it as not valid.
  }
};
