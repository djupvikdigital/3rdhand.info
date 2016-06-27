const compose = require('ramda/src/compose');
const docuri = require('docuri');
const filter = require('ramda/src/filter');
const Immutable = require('immutable');
const identity = require('ramda/src/identity');
const into = require('ramda/src/into');
const last = require('ramda/src/last');
const map = require('ramda/src/map');
const pick = require('ramda/src/pick');
const toPairs = require('ramda/src/toPairs');
const t = require('transducers.js');

const { remove, seq, take, toArray, transduce } = t;

const getUserId = docuri.route('user/:cuid');

function isObject(x) {
  return (
    x instanceof Object && Object.getPrototypeOf(x) === Object.getPrototypeOf({})
  );
}

function array() {
  // cast to array
  return Array.prototype.concat.apply([], arguments);
}

function keyIn() {
  const keySet = Immutable.Set(arguments);
  return (v, k) => keySet.has(k);
}

function shortCircuitScalars(fn) {
  return function (input) {
    return typeof input == 'object' ? fn(...arguments) : input;
  };
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

function propsAndMappersMapper(propsAndMapper) {
  const props = propsAndMapper.slice(0);
  const mapper = props.pop();
  if (props.every(Object.prototype.hasOwnProperty, this)) {
    const pairs = toPairs(pick(props, this));
    const args = pairs.map(last);
    return mapper.apply(this, args);
  }
  return null;
}

const mapObjectRecursively = shortCircuitScalars((obj, ..._p) => {
  const propsAndMappers = Array.isArray(_p[0]) ? _p : [_p];
  const f = shortCircuitScalars(input => {
    if (Array.isArray(input)) {
      return input.map(f);
    }
    else if (isObject(input)) {
      const results = propsAndMappers
        .map(propsAndMappersMapper, input)
        .filter(x => x != null);
      if (results.length) {
        return f(results[0]);
      }
      else {
        return map(f, input);
      }
    }
    return input;
  });
  return f(obj);
});

function createPropertyMapper(k, fn) {
  return function propertyMapper() {
    if (this.hasOwnProperty(k)) {
      return null;
    }
    this[k] = fn.apply(this, arguments);
    return this;
  };
}

function createFormatMapper(formatters) {
  if (formatters) {
    return createFunctionMapper(formatters, '');
  }
  return ((k, v) => v);
}

function maybe(fn) {
  return arg => arg ? fn(arg) : null;
}

// Public API

function argsToObject(...keys) {
  const reducer = (obj, arg, i) => {
    obj[keys[i]] = arg;
    return obj;
  };
  return () => keys.reduce(reducer, {});
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
  createFormatMapper,
  createPropertyMapper,
  getUserId(userId) {
    return getUserId(userId).cuid || userId;
  },
  getUserProps,
  keyIn,
  mapObjectRecursively,
  maybe,
  stripDbFields,
};
