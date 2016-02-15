var MyApplicationForm = React.createClass({
  changeUrl: function () {
    location.href = '/success';
  },
  render: function () {
    return (
      <Form url='/emails' onSuccess={ this.changeUrl }>
        <div className='form-group'>

          <Input name='email' validations={[
            { fn: required },
            { fn: minLength, args: { len: 3 } }
          ]}/>

          <Textarea name='textarea1' validations={[
            { fn: required },
            { fn: minLength, args: { len: 3 } }
          ]}/>
        </div>
      </Form>
    );
  }
});