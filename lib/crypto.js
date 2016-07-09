const Promise = require('bluebird');
const bcrypt = Promise.promisifyAll(require('bcrypt'));
const R = require('ramda');
const YAML = require('js-yaml');

const { array } = require('../src/scripts/utils.js');
const { read } = require('./utils.js');

const { serverSecret } = YAML.safeLoad(read('./config.yaml'));

function stringify(input) {
  return JSON.stringify(array(input, serverSecret));
}

// Public API

function compare(input, _hash) {
  if (!input || !_hash) {
    throw new Error('missing required arguments');
  }
  return bcrypt.compareAsync(input, _hash);
}

function hash(input) {
  return bcrypt.genSaltAsync(10).then(salt => bcrypt.hashAsync(input, salt));
}

const sign = R.compose(hash, stringify);

function verify(input, _hash) {
  if (!input || !_hash) {
    throw new Error('missing required arguments');
  }
  return bcrypt.compareAsync(stringify(input), _hash);
}

module.exports = { compare, hash, serverSecret, sign, verify };
