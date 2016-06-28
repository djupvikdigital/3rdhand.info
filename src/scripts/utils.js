const assoc = require('ramda/src/assoc');
const docuri = require('docuri');
const Immutable = require('immutable');
const last = require('ramda/src/last');
const map = require('ramda/src/map');
const pick = require('ramda/src/pick');
const toPairs = require('ramda/src/toPairs');

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

function keyIn(...args) {
  const keySet = Immutable.Set(args);
  return (v, k) => keySet.has(k);
}

function shortCircuitScalars(fn) {
  return function shortCircuitedScalars(...args) {
    const input = args[0];
    return typeof input == 'object' ? fn(...args) : input;
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
      return map(f, input);
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
  return arg => (arg ? fn(arg) : null);
}

// Public API

function argsToObject(...keys) {
  const reducer = (obj, arg, i) => assoc(keys[i], arg, obj);
  return (...args) => args.reduce(reducer, {});
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
