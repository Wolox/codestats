DEFAULT_RETRY_TIME     = 2000
STARTING_RETRIES_COUNT = 0
DEFAULT_MAX_RETRIES    = 10

@utils = @utils || {};
retry = (url, callback, configObject) ->
  configObject.retries++
  setTimeout(
    () ->
      configObject.retryIn *= 1.25
      utils.exponentialBackoff(url, callback, configObject)
  , configObject.retryIn
  )

setDefaults = (configObject) ->
  configObject = configObject || {}
  configObject.retries = configObject.retries || STARTING_RETRIES_COUNT
  configObject.retryIn = configObject.retryIn || DEFAULT_RETRY_TIME
  configObject.maxRetries = configObject.maxRetries || DEFAULT_MAX_RETRIES

  configObject

utils.exponentialBackoff = (url, callbacks, configObject) ->
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
      callbacks.error(data)
  })
