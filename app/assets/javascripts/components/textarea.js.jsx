var Textarea = React.createClass({
  /* Create an initial state with the value passed to the input
   * or an empty value */
  getInitialState: function () {
    return {
      edited:       false,
      elemType:     this.props.elemType || 'input',
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
  },

  render: function () {
    var markAsValid = this.state.isValid;

    var className = '';

    // We prioritize marking it as required over marking it as not valid.
    className = markAsValid ? '' : 'error';

    return (
      <div className={ className }>
        <textarea
               name      = { this.props.name     }
               className = { className           }
               onChange  = { this.setValue       }
               onBlur    = { this.onBlur         }
               value     = { this.state.value    }/>
        <span>{ markAsValid ? null : this.state.serverErrors || this.state.validationError }</span>
      </div>
    );
  }
});
