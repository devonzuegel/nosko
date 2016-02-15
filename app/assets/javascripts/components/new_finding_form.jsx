var NewFindingForm = React.createClass({
  render: function () {
    return (
      <Form url='/findings' className='form-inline' onSubmit={ this.handleSubmit }>
        <div className='form-group'>

          <Input name='url' className='form-control' placeholder='URL' validations={[
            { fn: required },
            { fn: validURL }
          ]}/>

          <Input name='title' className='form-control' placeholder='Title' validations={[
            { fn: required },
            { fn: minLength, args: { len: 3 } }
          ]}/>

          <select className='form-control' name='kind' defaultValue='Other'>{
            this.props.kinds.map(function(kind, i) {
              return (<option value={ kind } key={ i }>{ kind }</option>);
            })
          }
          </select>
        </div>
      </Form>
    );
  }
});