var Form = React.createClass({
  propTypes: {
    url:          React.PropTypes.string.isRequired,
    handleSubmit: React.PropTypes.func.isRequired,
    validations:  React.PropTypes.array
  },

  getInitialState: function () {
    return {
      isSubmitting: false,
      isValid:      false
    };
  },

  componentWillMount: function () {
    this.model  = {}; // We add a model to use when submitting the form
    this.inputs = {}; // We create a map of traversed inputs
  },

  // Validate the form when it loads.
  componentDidMount: function () {
    Object.keys(this.inputs).forEach(function (name) {
      console.log(name);
    });
    this.validateForm();
    this.setState(this.getInitialState());
  },

  registeredInputs: function (children) {
    return React.Children.map(children, function(child) {
      is_input = child.props && child.props.name;
      if (is_input) {
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
      return child;
    }.bind(this));
  },

  validate: function (component) {
    var isValid = true;
    if (component.props.validations && (component.state.value || component.state.edited)) {
      component.props.validations.forEach(function (validation) {
        if (!validation.fn(component.state.value, validation.args)) {
          isValid = false;
        }
      });
    }

    component.setState({  // Now we et the state of the input based on the validation
      isValid: isValid,
    }, this.validateForm);
  },

  clearForm: function () {
    this.setState(this.getInitialState())
    Object.keys(this.inputs).forEach(function (name) {
      this.inputs[name].setState({ value: '' });
    }.bind(this));
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
    this.inputs[component.props.name] = component;
    this.model[component.props.name]  = component.state.value;
    this.validate(component);
  },

  detachFromForm: function (component) {
    delete this.inputs[component.props.name];
    delete this.model[component.props.name];
    // Delete the model property if the component is removed.
  },

  updateModel: function (component) {
    Object.keys(this.inputs).forEach(function (name) {
      this.model[name] = this.inputs[name].state.value;
    }.bind(this));
  },

  // We prevent the form from default behaviour, update model and log out the value.
  submitForm: function (event) {
    event.preventDefault();
    this.setState({ isSubmitting: true });

    this.updateModel();
    this.validateForm();
    if (!this.state.isValid)  return;

    $.post(this.props.url, { finding: this.model }, (function(_this) {
      return function(data) {
        _this.props.handleSubmit(data);
        return _this.clearForm();
      };
    })(this), 'JSON');
  },

  render: function () {
    return (
      <form onSubmit={ this.submitForm }>
        { this.registeredInputs(this.props.children) }
        <button className='btn btn-primary' type='submit'
                disabled={ !this.state.isValid || this.state.isSubmitting }>Submit</button>
      </form>
    );
  }
});
