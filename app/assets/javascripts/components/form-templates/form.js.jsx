var Form = React.createClass({
  propTypes: {
    url:               React.PropTypes.string.isRequired,
    handleSubmit:      React.PropTypes.func.isRequired,
    clearOnSubmit:     React.PropTypes.bool,
    baseModel:         React.PropTypes.object,
    submitButton:      React.PropTypes.string,
    includeLoadingGif: React.PropTypes.bool,
    includeSuccessDiv: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      clearOnSubmit:      true,
      baseModel:          {},
      includeLoadingGif:  false,
      includeSuccessDiv:  false
    };
  },

  getInitialState: function () {
    return {
      submitButton: 'Submit',
      isSubmitting: false,
      isValid:      false
    };
  },

  componentDidUpdate: function () {
    if (this.props.includeLoadingGif) {
      if (this.state.isSubmitting) {
        $('#loadingGif').show();
        setTimeout(function(){ }, 1000);
      } else {
        $('#loadingGif').hide();
      }
    }
  },

  componentWillMount: function () {
    this.model  = this.props.baseModel; // We add a model to use when submitting the form
    this.inputs = {};                   // We create a map of traversed inputs
  },

  // Validate the form when it loads.
  componentDidMount: function () {
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
    if (component.getValidations() && (component.state.value || component.state.edited)) {
      component.getValidations().forEach(function (validation) {
        if (!validation.fn(component.state.value, validation.args)) {
          isValid = false;
        }
      });
    }

    component.setState({ isValid: isValid }, this.validateForm());
  },

  clearForm: function () {
    this.setState(this.getInitialState())
    Object.keys(this.inputs).forEach(function (name) {
      this.inputs[name].setState({ value: '' });
    }.bind(this));
  },

  successDiv: function () {
    $('#successfulSaveMessage').fadeIn(100).delay(800).fadeOut(1000);
  },

  validateForm: function () {
    var allAreValid = true;
    var inputs      = this.inputs;

    Object.keys(inputs).forEach(function (name) {
      var input              = inputs[name];
      var isRequiredButEmpty = (input.props.required && input.state.value == '');
      if (!input.state.isValid || isRequiredButEmpty)   allAreValid = false;
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

    _this = this;
    $.put(this.props.url, { user: this.model }, function (data) {
      _this.setState({ isSubmitting: false });
      _this.props.handleSubmit(data);
      if (_this.props.includeSuccessDiv)  _this.successDiv();
      if (_this.props.clearOnSubmit)      _this.clearForm();
    });
  },

  render: function () {
    img_link = 'http://earthcharter.org/wp-content/themes/canvas/includes/images/prettyPhoto/loader.gif'
    return (
      <form onSubmit={ this.submitForm }>
        <img src={ img_link } id='loadingGif'/>
        { this.registeredInputs(this.props.children) }
        <button className='btn btn-primary' type='submit' id='btnSubmit'
                disabled={ !this.state.isValid || this.state.isSubmitting }>{
          this.props.submitButton
        }</button>
        <div id='successfulSaveMessage'>Saved successfully!</div>
      </form>
    );
  }
});
