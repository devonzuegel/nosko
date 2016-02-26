var NewFindingForm = React.createClass({
  render: function () {
    return (
      <Form url='/findings' className='form-inline' handleSubmit={ this.props.handleNewFinding }>
        <div className='form-group'>

          <Input name='url' className='form-control' placeholder='URL' validations={[
            { fn: required },
            { fn: validURL }
          ]}/>

          <Input name='title' className='form-control' placeholder='Title' validations={[
            { fn: required },
            { fn: minLength, args: { len: 3 } }
          ]}/>

          <Select className='form-control' name='kind' options={ this.props.kinds } validations={[
            { fn: required }
          ]}/>
        </div>
      </Form>
    );
  }
});