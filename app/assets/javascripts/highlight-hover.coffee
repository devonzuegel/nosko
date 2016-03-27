$(document).ready ->
  $('span.highlight').mouseover (event) ->
    highlight_span = $(this)
    console.log highlight_span.text()
