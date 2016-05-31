ReactCSSTransitionGroup = React.createFactory(React.addons.CSSTransitionGroup)

@TodoList2 = React.createClass
  getInitialState: ->
    items: ['hello', 'world', 'click', 'me']

  handleAdd: ->
    newItems = @state.items.concat([prompt('Enter some text')])
    @setState items: newItems

  handleRemove: (i) ->
    newItems = @state.items
    newItems.splice(i, 1)
    @setState items: newItems

  render: ->
    items = @state.items.map (item, i) =>
      React.DOM.div
        key:      item
        onClick:  @handleRemove.bind(this, i)
        item

    React.DOM.div id: 'example',
      React.DOM.button onClick: @handleAdd, 'Add Item'
      React.createClass ReactCSSTransitionGroup
        transitionName: 'example'
        transitionEnterTimeout: 0
        transitionLeaveTimeout: 0
        items