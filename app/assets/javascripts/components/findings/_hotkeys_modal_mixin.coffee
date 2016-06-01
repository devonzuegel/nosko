@HotkeysModal =
  hotkeys_modal_btn: ->
    React.DOM.button
      className:     'btn btn-secondary'
      'data-toggle': 'modal'
      href:          '#hotkeys-modal'
      Utils.ion_icon_link('ios-help-outline', null, 'Hot keys')

  componentDidMount: ->
    Mousetrap.bind 'h', (e) =>
      e.preventDefault()
      $( '#hotkeys-modal' ).modal( 'toggle' );