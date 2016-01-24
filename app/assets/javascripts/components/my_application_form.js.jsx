var MyApplicationForm = React.createClass({
  changeUrl: function () {
    location.href = '/success';
  },
  render: function () {
    return (
      <Form url="/emails" onSuccess={this.changeUrl}>
        <div className='form-group'>

          <label>Email</label>
          <Input name="email" validations={[
            { fn: required },
            { fn: minLength, args: { len: 3 } }
          ]}/>

        </div>
      </Form>
    );
  }
});
          // <label>Number</label>
          // <Input name="number" validations="isNumeric,isLength:4:12"/>
