var Input = React.createClass({
  mixins: [FormElemMixin],

  propTypes: {
    defaultValue: React.PropTypes.string
  },

  getDefaultValue: function () {
    return this.props.defaultValue || '';
  },

  render: function () {
    return (
      <div>
        <span>{ this.getErrors() }</span>
        <input
          type        = 'text'
          name        = { this.props.name         }
          placeholder = { this.props.placeholder  }
          className   = { this.getClassName()     }
          onChange    = { this.setValue           }
          onBlur      = { this.onBlur             }
          value       = { this.state.value        }/>
      </div>
    );
  }
});
