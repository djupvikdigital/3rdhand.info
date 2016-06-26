const URL = require('urlHelpers');

function init(state) {
  return {
    type: 'INIT',
    payload: { state },
  };
}

function setCurrentParams(payload) {
  const type = 'SET_CURRENT_PARAMS';
  return { type, payload };
}

module.exports = { init, setCurrentParams };
