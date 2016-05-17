var SettingsForm = React.createClass({
  propTypes: {
    user:                         React.PropTypes.UserFacade.isRequired,
    reminders_frequency_options:  React.PropTypes.arrayOf(React.PropTypes.string).isRequired,
    share_by_default_options:     React.PropTypes.arrayOf(React.PropTypes.shape({
      label:   React.PropTypes.string.isRequired,
      val:     React.PropTypes.string.isRequired
    })).isRequired,
  },

  handleUpdate: function (data) { },

  render: function () {
    return (
      <Form url={ '/users/' + this.props.user.id } className='form-inline' handleSubmit={ this.handleUpdate }
            clearOnSubmit={ false }  baseModel={ this.props.user } submitButton='Save' includeSuccessDiv={ true }>
        <div className='form-group'>

          <label>Name</label>
          <Input name='name' required value={ this.props.user.name } placeholder='Name' className='form-control' validations={[
            { fn: required }
          ]}/>

          <label>Who can see my future findings by default?</label>
          <Select name         = 'sharing_attributes[share_by_default]'
                  defaultValue = { ''+this.props.user.sharing.share_by_default }
                  options      = { this.props.share_by_default_options }
                  className    = 'form-control' validations={[ { fn: required } ]}
          />

          <label>Email digest frequency</label>
          <Select name         = 'sharing_attributes[reminders_frequency]'
                  defaultValue = { ''+this.props.user.sharing.reminders_frequency }
                  options      = { this.props.reminders_frequency_options }
                  className    = 'form-control' validations={[ { fn: required } ]}
          />

        </div>
      </Form>
    );
  }
});