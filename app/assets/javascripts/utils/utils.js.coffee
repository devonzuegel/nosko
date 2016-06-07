@Utils =
  return_false: -> return false

  amountFormat: (amt) ->
    '$ ' + Number(amt).toLocaleString()

  validURL: (url) ->
    pattern = /^(?:(?:(?:https?|ftp):)?\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})).?)(?::\d{2,5})?(?:[\/?#]\S*)?$/
    pattern.test(url)

  required: (content) ->
    (content != null) and (content != '')

  minLength: (content, args) ->
    (content.length >= args.len)

  puts: (to_print) ->
    console.log(JSON.stringify(to_print, null, '\t'))

  scroll_to: (id) ->
    return if $("##{id}").is_fully_in_view()
    document.getElementById(id).scrollIntoView(true)

  numberWithCommas: (x) ->
    x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

  ion_icon_link: (name, onclick, text=null, classes='', to_right=false) ->
    React.DOM.a className: "card-button #{classes}", onClick: onclick,
      @ion_icon(name, 'inline-block')
      if text
        React.DOM.div className: "icon-text", text

  ion_icon: (name, classes='') ->
    React.DOM.div className: classes, onClick: onclick,
      React.DOM.div className: "ion-icon ion-#{name}"

  copyToClipboard: (text) ->
    textArea = document.createElement('textarea')
    # *** This styling is an extra step which is likely not required. ***
    #
    # Why is it here? To ensure:
    # 1. the element is able to have focus and selection.
    # 2. if element was to flash render it has minimal visual impact.
    # 3. less flakyness with selection and copying which **might** occur if
    #    the textarea element is not visible.
    #
    # The likelihood is the element won't even render, not even a flash,
    # so some of these are just precautions. However in IE the element
    # is visible whilst the popup box asking the user for permission for
    # the web page to copy to the clipboard.
    #
    # Place in top-left corner of screen regardless of scroll position.
    textArea.style.position = 'fixed'
    textArea.style.top = 0
    textArea.style.left = 0
    # Ensure it has a small width and height. Setting to 1px / 1em
    # doesn't work as this gives a negative w/h on some browsers.
    textArea.style.width = '2em'
    textArea.style.height = '2em'
    # We don't need padding, reducing the size if it does flash render.
    textArea.style.padding = 0
    # Clean up any borders.
    textArea.style.border = 'none'
    textArea.style.outline = 'none'
    textArea.style.boxShadow = 'none'
    # Avoid flash of white box if rendered for any reason.
    textArea.style.background = 'transparent'
    textArea.value = text
    document.body.appendChild textArea
    textArea.select()
    try
      successful = document.execCommand('copy')
      # msg = if successful then 'successful' else 'unsuccessful'
      # console.log 'Copying text command was ' + msg
    catch err
      # console.log 'Oops, unable to copy'
    document.body.removeChild textArea
    return