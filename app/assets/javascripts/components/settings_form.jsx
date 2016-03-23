var SettingsForm = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired
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

          <label>Share by default?</label>
          <Select name         = 'sharing_attributes[share_by_default]'
                  defaultValue = { ''+this.props.user.sharing.share_by_default }
                  options      = { [{ label: 'No', val: 'false' }, { label: 'Yes', val: 'true' }] }
                  className    = 'form-control' validations={[ { fn: required } ]}
          />

          <label>Email digest frequency</label>
          <Select name         = 'sharing_attributes[reminders_frequency]'
                  defaultValue = { ''+this.props.user.sharing.reminders_frequency }
                  options      = { ['Daily', 'Every two days', 'Weekly'] }
                  className    = 'form-control' validations={[ { fn: required } ]}
          />

        </div>
      </Form>
    );
  }
});