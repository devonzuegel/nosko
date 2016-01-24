var Form = React.createClass({
  getInitialState: function () {
    return { isSubmitting: false };
  },

  componentWillMount: function () {
    this.model = {}; // We add a model to use when submitting the form
    this.inputs = {}; // We create a map of traversed inputs
  },
  registeredInputs: function (children) {
    return React.Children.map(children, function(child) {
      // We do a simple check for "name" on the child, which indicates it is an input.
      if (child.props && child.props.name) {
        console.log('Registering "' + child.props.name + '" to form...');
        child = React.cloneElement(child, {
          attachToForm:   this.attachToForm,
          detachFromForm: this.detachFromForm
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

  // All methods defined are bound to the component by React JS, so it is safe to use "this"
  // even though we did not bind it. We add the input component to our inputs map
  attachToForm: function (component) {
    console.log('Attaching "' + component.props.name + '" to form...')
    this.inputs[component.props.name] = component;

    // We add the value from the component to our model, using the
    // name of the component as the key. This ensures that we
    // grab the initial value of the input
    this.model[component.props.name] = component.state.value;
  },
  detachFromForm: function (component) {
    console.log('Detaching "' + component.props.name + '" to form...')
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

  // We prevent the form from doing its native
  // behaviour, update the model and log out the value
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
