var FindingForm = React.createClass({
  render: function () {
    return (
      <Form url='/findings' className='form-inline' handleSubmit={ this.props.handleNewFinding }>
        <div className='form-group'>

          <Input name='url'   className='form-control' required placeholder='URL' validations={[
            { fn: Utils.required },
            { fn: Utils.validURL }
          ]}/>

          <Input name='title' className='form-control' required placeholder='Title' validations={[
            { fn: Utils.required },
            { fn: Utils.minLength, args: { len: 3 } }
          ]}/>

          <Select name='kind' className='form-control' required options={ this.props.kinds } validations={[
            { fn: Utils.required }
          ]}/>
        </div>
      </Form>
    );
  }
});