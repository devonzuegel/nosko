var MyApplicationForm = React.createClass({
  render: function () {
    return (
      <Form>
        <label>Email</label>
        <Input name="email" validations="isEmail" validationError="This is not a valid email"/>
      </Form>
    );
  }
});
