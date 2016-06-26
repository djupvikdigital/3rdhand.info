const Promise = require('bluebird');
const bcrypt = Promise.promisifyAll(require('bcrypt'));
const t = require('transducers.js');
const YAML = require('js-yaml');

const { array } = require('../src/scripts/utils.coffee');
const { read } = require('./utils.js');

const { serverSecret } = YAML.safeLoad(read('./config.yaml'));

function stringify(input) {
  return JSON.stringify(array(input, serverSecret));
}

// Public API

function compare(input, hash) {
  if (!input || !hash) {
    throw new Error('missing required arguments');
  }
  return bcrypt.compareAsync(input, hash)
}

function hash(input) {
  return bcrypt.genSaltAsync(10).then(salt => bcrypt.hashAsync(input, salt));
}

const sign = t.compose(hash, stringify);

function verify(input, hash) {
  if (!input || !hash) {
    throw new Error('missing required arguments');
  }
  return bcrypt.compareAsync(stringify(input), hash);
}

module.exports = { compare, hash, serverSecret, sign, verify };
