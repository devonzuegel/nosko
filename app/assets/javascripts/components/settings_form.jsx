var SettingsForm = React.createClass({
  propTypes: {
    handleUpdate:   React.PropTypes.func.isRequired,
    user:           React.PropTypes.object.isRequired
  },

  render: function () {
    return (
      <Form url={ '/users/' + this.props.user.id } className='form-inline' handleSubmit={ this.props.handleUpdate }
            clearOnSubmit={ false }  baseModel={ this.props.user }>
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