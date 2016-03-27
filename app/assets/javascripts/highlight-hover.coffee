$(document).ready ->
  console.log "'#{$('#test').html().trim()}'"
  $('span.highlight').mouseover (event) ->
    highlight_span = $(this)
    console.log highlight_span.text()
