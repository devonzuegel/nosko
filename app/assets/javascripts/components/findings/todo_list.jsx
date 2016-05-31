var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

var TodoList = React.createClass({
    getInitialState: function() {
      return {items: ['hello', 'world', 'click', 'me']};
    },
    handleAdd: function() {
      var newItems =
      this.state.items.concat([prompt('Enter some text')]);
      this.setState({items: newItems});
    },
    handleRemove: function(i) {
      var newItems = this.state.items;
      newItems.splice(i, 1);
      this.setState({items: newItems});
    },
    render: function() {

      var items = this.state.items.map(function(item, i) {
        return (
          <div key={item} onClick={this.handleRemove.bind(this, i)}>
            {item}
          </div>
        );
      }.bind(this));

      return (
        <div id='example'>
          <button onClick={this.handleAdd}>Add Item</button>
          <ReactCSSTransitionGroup transitionName='example' transitionEnterTimeout={0} transitionLeaveTimeout={0}>
            {items}
          </ReactCSSTransitionGroup>
        </div>
      );
    }
  });