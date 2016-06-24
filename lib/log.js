const winston = require('winston');

const logger = new winston.Logger({
  transports: [new winston.transports.Console({ level: 'debug' })]
});

function error(err) {
  if (!err) {
    return console.trace();
  }
  logger.error(err.message);
  logger.debug(err.stack);
  if (!err.stack) {
    console.trace();
  }
}

module.exports = Object.assign({}, logger, { error });
