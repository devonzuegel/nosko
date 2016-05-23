$.put = function(url, data, callback, dataType = 'JSON') {
  return $.ajax({
    method:   'PUT',
    url:      url,
    dataType: dataType,
    data:     data,
    success:  callback
  });
}

$.delete = function(url, data, callback, dataType = 'JSON') {
  return $.ajax({
    method:   'DELETE',
    url:      url,
    dataType: dataType,
    data:     data,
    success:  callback
  });
}

$.patch = function(url, data, callback, dataType = 'JSON') {
  return $.ajax({
    method:       'PATCH',
    url:          url,
    dataType:     dataType,
    data:         data,
    success:      callback
  })
}