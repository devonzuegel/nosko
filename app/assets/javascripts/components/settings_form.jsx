var SettingsForm = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired
  },

  handleUpdate: function (data) {
    alert('Saved!');
  },

  render: function () {
    return (
      <Form url={ '/users/' + this.props.user.id } className='form-inline' handleSubmit={ this.handleUpdate }
            clearOnSubmit={ false }  baseModel={ this.props.user } submitButton='Save'>
        <div className='form-group'>

          <label>Name</label>
          <Input name='name'  className='form-control' required value={ this.props.user.name } placeholder='Name' validations={[
            { fn: required }
          ]}/>
        </div>
      </Form>
    );
  }
});