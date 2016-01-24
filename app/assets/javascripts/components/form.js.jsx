var Form = React.createClass({
  getInitialState: function () {
    return {
      isSubmitting: false,
      isValid:      true
    };
  },

  componentWillMount: function () {
    this.model = {}; // We add a model to use when submitting the form
    this.inputs = {}; // We create a map of traversed inputs
  },

  // Validate the form when it loads.
  componentDidMount: function () {
    this.validateForm();
  },

  registeredInputs: function (children) {
    return React.Children.map(children, function(child) {
      // We do a simple check for "name" on the child, which indicates it is an input.
      if (child.props && child.props.name) {
        // console.log('Registering "' + child.props.name + '" to form...');
        child = React.cloneElement(child, {
          attachToForm:   this.attachToForm,
          detachFromForm: this.detachFromForm,
          validate:       this.validate
        });
      }
      // If the child has its own children, traverse through them also
      if (child.props && child.props.children) {
        child = React.cloneElement(child, {
          children: this.registeredInputs(child.props.children)
        });
      }
      return child
    }.bind(this));
  },

  validate: function (component) {
    if (!component.props.validations) {
      return;       // If no validations property, do not validate
    }

    var isValid = true;
    component.props.validations.forEach(function (validation) {
      if (!validation.fn(component.state.value, validation.args)) {
        isValid = false;
      }
    });

    // Now we et the state of the input based on the validation
    component.setState({
      isValid: isValid,
    }, this.validateForm);
  },

  validateForm: function () {
    var allAreValid = true;
    var inputs      = this.inputs;
    Object.keys(inputs).forEach(function (name) {
      if (!inputs[name].state.isValid) {
        allAreValid = false;
      }
    });
    this.setState({ isValid: allAreValid });
  },

  // All methods defined are bound to the component by React JS, so it is safe to use "this"
  // even though we did not bind it. We add the input component to our inputs map
  attachToForm: function (component) {
    // console.log('Attaching "' + component.props.name + '" to form...')
    this.inputs[component.props.name] = component;
    this.model[component.props.name]  = component.state.value;
    this.validate(component);
  },
  detachFromForm: function (component) {
    // console.log('Detaching "' + component.props.name + '" to form...')
    delete this.inputs[component.props.name];

    // We of course have to delete the model property
    // if the component is removed
    delete this.model[component.props.name];
  },

  updateModel: function (component) {
    Object.keys(this.inputs).forEach(function (name) {
      this.model[name] = this.inputs[name].state.value;
    }.bind(this));
  },

  // We prevent the form from default behaviour, update model and log out the value.
  submit: function (event) {
    event.preventDefault();
    this.setState({ isSubmitting: true });
    this.updateModel();
    console.log(this.model);
    // MyAjaxService.post(this.props.url, this.model)
    //   .then(this.props.onSuccess);
  },

  render: function () {
    return (
      <form onSubmit={this.submit}>
        {this.registeredInputs(this.props.children)}
        <button type="submit" disabled={this.state.isSubmitting}>Submit</button>
      </form>
    );
  }
});
