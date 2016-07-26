const assoc = require('ramda/src/assoc');
const docuri = require('docuri');
const Immutable = require('immutable');
const moment = require('moment-timezone');
const pick = require('ramda/src/pick');

const getUserId = docuri.route('user/:cuid');

function array() {
  // cast to array
  return Array.prototype.concat.apply([], arguments);
}

function keyIn(...args) {
  const keySet = Immutable.Set(args);
  return (v, k) => keySet.has(k);
}

function createFunctionMapper(functionMap, noValue) {
  return (k, v) => {
    if (typeof v == 'undefined' && typeof noValue != 'undefined') {
      return noValue;
    }
    else if (typeof functionMap[k] == 'function') {
      return functionMap[k](v);
    }
    return v;
  };
}

function createFormatMapper(formatters) {
  if (formatters) {
    return createFunctionMapper(formatters, '');
  }
  return ((k, v) => v);
}

function maybe(fn) {
  return arg => (arg ? fn(arg) : null);
}

// Public API

function argsToObject(...keys) {
  const reducer = (obj, arg, i) => assoc(keys[i], arg, obj);
  return (...args) => args.reduce(reducer, {});
}

function createDatetimeStruct(date) {
  return {
    utc: moment.utc(date).toISOString(),
    timezone: moment.tz.guess(),
  };
}

function getUserProps(user) {
  return pick(['_id', 'name'], user);
}

function stripDbFields(obj) {
  const isMap = Immutable.Map.isMap(obj);
  const m = (isMap ? obj : Immutable.Map(obj)).filterNot(keyIn('_id', '_rev'));
  return isMap ? m : m.toObject();
}

module.exports = {
  argsToObject,
  array,
  createDatetimeStruct,
  createFormatMapper,
  getUserId(userId) {
    return getUserId(userId).cuid || userId;
  },
  getUserProps,
  keyIn,
  maybe,
  stripDbFields,
};
