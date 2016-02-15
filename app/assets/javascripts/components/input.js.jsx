var Input = React.createClass({
  mixins: [FormElemMixin],

  render: function () {
    // We prioritize marking it as required over marking it as not valid.
    var className = this.state.isValid ? '' : 'error';

    return (
      <div className={className}>
        <input type      = 'text'
               name      = { this.props.name  }
               className = { className        }
               onChange  = { this.setValue    }
               onBlur    = { this.onBlur      }
               value     = { this.state.value }/>
        <span>{ this.state.isValid ? null : this.state.serverErrors || this.state.validationError }</span>
      </div>
    );
  }
});
