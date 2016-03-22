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
    url:      _url,
    dataType: dataType,
    data:     data,
    success:  callback
  });
}