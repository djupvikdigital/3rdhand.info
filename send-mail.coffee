Promise = require 'bluebird'

logger = require './log.coffee'

sendMail = (settings) ->
  Promise.resolve
    response: settings

defaults =
  from: 'mail@3rdhand.info'

module.exports = (options) ->
  settings = Object.assign {}, defaults, options
  sendMail(settings).then (info) ->
    logger.log 'info', 'Message sent: %j', info.response
    return info
