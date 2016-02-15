var Textarea = React.createClass({
  mixins: [FormElemMixin],

  render: function () {
    // We prioritize marking it as required over marking it as not valid.
    var className = this.state.isValid ? '' : 'error';
    var errors    = this.state.isValid ? null : this.state.serverErrors || this.state.validationError

    return (
      <div className={className}>
        <textarea
          name        = { this.props.name         }
          placeholder = { this.props.placeholder  }
          className   = { className               }
          onChange    = { this.setValue           }
          onBlur      = { this.onBlur             }
          value       = { this.state.value        }/>

        <span>{ errors }</span>
      </div>
    );
  }
});
