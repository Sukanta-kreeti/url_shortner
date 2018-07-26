$('.urls.shortened').ready ->
  $('#short-url').popover 'show'
  $('body').click ->
    $('#short-url').popover 'hide'
    return
  range = document.createRange()
  selection = window.getSelection()
  range.selectNodeContents document.getElementById('short-url')
  selection.removeAllRanges()
  selection.addRange range
  return
$('.urls.index').ready ->
  $('#url_original_url').attr 'size', $('#url_original_url').attr('placeholder').length
  return
