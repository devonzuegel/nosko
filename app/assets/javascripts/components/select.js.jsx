var Select = React.createClass({
  mixins: [FormElemMixin],

  render: function () {
    // We prioritize marking it as required over marking it as not valid.
    var className = this.state.isValid ? '' : 'error';
    var errors    = this.state.isValid ? null : this.state.serverErrors || this.state.validationError

    return (
      <div className={className}>
        <select
          name         = { this.props.name  }
          className    = { this.className() }
          onChange     = { this.setValue    }
          onBlur       = { this.onBlur      }>{

          this.props.options.map(function(opt, i) {
            return (<option value={ opt } key={ i }>{ opt }</option>);
          })

        }</select>
        <span>{ errors }</span>
      </div>
    );
  }
});
