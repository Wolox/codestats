@organizations = @organizations || {};
retry = (url, callback, configObject) ->
  configObject.retries++
  setTimeout(
    () ->
      configObject.retryIn *= 1.25
      organizations.exponentialBackoff(url, callback, configObject)
  , configObject.retryIn
  )

setDefaults = (configObject) ->
  configObject = configObject || {}
  configObject.retries = configObject.retries || 0
  configObject.retryIn = configObject.retryIn || 2000
  configObject.maxRetries = configObject.maxRetries || 10

  configObject

organizations.exponentialBackoff = (url, callbacks, configObject) ->
  configObject = setDefaults(configObject)
  return callbacks.timeout() if configObject.maxRetries == configObject.retries
  $.get({
    url: url
    datatype : "application/json"
    statusCode: {
      202: (data, textStatus, jqXHR) ->
        retry(url, callbacks, configObject)
      200: (data, textStatus, jqXHR) ->
        callbacks.success(data)
    }
    error: (data, textStatus, jqXHR) ->
      console.log('error')
  })