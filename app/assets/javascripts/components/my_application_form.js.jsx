var MyApplicationForm = React.createClass({
  changeUrl: function () {
    location.href = '/success';
  },
  render: function () {
    return (
      <Form url="/emails" onSuccess={this.changeUrl}>
        <div className='form-group'>
          <label>Email</label>
          <Input name="email" validations="isEmail" validationError="This is not a valid email"/>

          <label>Number</label>
          <Input name="number" validations="isNumeric,isLength:4:12"/>
        </div>
      </Form>
    );
  }
});
