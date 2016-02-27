var Select = React.createClass({
  mixins: [FormElemMixin],

  propTypes: {
    options:      React.PropTypes.array.isRequired,
    defaultValue: React.PropTypes.string
  },

  getDefaultValue: function () {
    return this.props.defaultValue || this.props.options[0] || '';
  },

  render: function () {
    return (<div>
      <span>{ this.getErrors() }</span>
      <select
        name         = { this.props.name     }
        className    = { this.getClassName() }
        onChange     = { this.setValue       }
        value        = { this.state.value    }
        onBlur       = { this.onBlur         }>{

          this.props.options.map(function(opt, i) {
            return (<option value={ opt } key={ i }>{ opt }</option>);
          })

      }</select>
    </div>);
  }
});
