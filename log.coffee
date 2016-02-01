winston = require 'winston'

logger = new winston.Logger(transports: [
  new winston.transports.Console(level: 'debug')
])

module.exports = Object.assign {}, logger, {
  error: (err) ->
    logger.error err.message
    logger.debug err.stack
}
