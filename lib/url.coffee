t = require 'transducers.js'

Lang = require './lang.coffee'
utils = require '../src/scripts/utils.coffee'

splitPath = (path) ->
  parts = path.split '/'
  i = parts.length - 1
  obj = {
    path: parts
  }
  filenameParts = parts[i].split '.'
  parts[i] = filenameParts[0]
  obj.filename = filenameParts
  obj

validate = (input, validation) ->
  if validation.test input
    input
  else
    null

validationReducer = (parts, item, i, keysAndValidations) ->
  item[1] = validate parts[0], item[1]
  parts.shift() if item[1]
  if keysAndValidations.length > i + 1
    parts
  else
    keysAndValidations

getParams = (arg) ->
  if !arg
    return {}
  if typeof arg == 'string' || arg instanceof String
    path = arg
  else if arg.splat
    path = arg.splat
  else
    return Object.assign {}, arg
  obj = splitPath path
  lang = obj.filename.filter(Lang.negotiateLang)[0]
  parts = obj.path
  i = parts.length - 1
  if parts[i] == lang
    parts[i] = ''
  keys = [ 'year', 'month', 'day', 'slug', 'view' ]
  twoDigits = /^\d{2}$/
  str = /^.+$/
  validation = [
    /^\d{4}$/
    twoDigits
    twoDigits
    str
    str
  ]
  parts = parts.filter Boolean
  params = t.toObj(
    utils.zip(keys, validation).reduce validationReducer, parts
    utils.filterValues()
  )
  params.userId = arg.userId if arg.userId
  params.lang = lang if lang
  params

getServerUrl = (req) ->
  req.protocol + '://' + req.get('Host')

module.exports = { getParams, getServerUrl, splitPath }
