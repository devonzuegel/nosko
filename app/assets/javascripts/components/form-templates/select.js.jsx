var Select = React.createClass({
  mixins: [FormElemMixin],

  propTypes: {
    options:      React.PropTypes.array.isRequired,
    optionsVals:  React.PropTypes.array,
    defaultValue: React.PropTypes.string
  },

  getDefaultValue: function () {
    return this.props.defaultValue || this.props.options[0].val || '';
  },

  render: function () {
    return (<div>
      <span>{ this.getErrors() }</span>
      <select
        name         = { this.props.name     }
        className    = { this.getClassName() }
        onChange     = { this.setValue       }
        defaultValue = { this.props.defaultValue }
        onBlur       = { this.onBlur         }>{

          this.props.options.map(function(opt, i) {
            if (typeof(opt) == 'string')  opt = { val: opt, label: opt }
            return (<option value={ opt.val } key={ i }>{ opt.label }</option>);
          })

      }</select>
    </div>);
  }
});
