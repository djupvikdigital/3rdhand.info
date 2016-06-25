const Promise = require('bluebird');

const logger = require('./log.js');

function sendMail(settings) {
  return Promise.resolve({ response: settings });
}

const defaults = {
  from: 'mail@3rdhand.info',
};

module.exports = options => {
  const settings = Object.assign({}, defaults, options);
  sendMail(settings).then(info => {
    logger.log('info', 'Message sent: %j', info.response);
    return info;
  });
};
