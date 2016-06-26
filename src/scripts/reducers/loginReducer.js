const Immutable = require('immutable');

const initialState = Immutable.fromJS({
  isLoggedIn: false,
});

function mergeUser(state, { user, timestamp }) {
  if (user) {
    return state.merge({
      user: user,
      authenticationTime: timestamp,
      isLoggedIn: true,
    });
  }
  return initialState;
}

function resetState() {
  return initialState;
}

const reducers = {
  LOGIN_FULFILLED: mergeUser,
  SET_LOGGEDIN_USER: mergeUser,
  LOGIN_REJECTED(state, payload) {
    return initialState.set('error', payload);
  },
  LOGOUT_PENDING: resetState,
  SESSION_TIMEOUT: resetState,
  INIT(state, payload) {
    return state.merge(payload.state.loginState);
  },
}

function loginReducer(_state, { type, payload }) {
  const state = _state || initialState;
  if (typeof reducers[type] == 'function') {
    return reducers[type](state, payload);
  }
  return state;
}

module.exports = loginReducer;
