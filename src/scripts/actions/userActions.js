const ReduxRouter = require('react-router-redux');

const API = require('api');
const URL = require('urlHelpers');
const utils = require('../utils.js');

function changePassword(userId, data) {
  return {
    type: 'CHANGE_PASSWORD',
    payload: API.changePassword(userId, data),
  };
}

function login(data) {
  return dispatch => (
    dispatch({
      type: 'LOGIN',
      payload: API.login(data),
    }).then(res => {
      const { value } = res;
      const { from } = data;
      const params = from ? JSON.parse(from) : {};
      params.userId = utils.getUserId(value.user._id);
      dispatch(
        ReduxRouter.push({ pathname: URL.getPath(params), state: params })
      );
      return res;
    })
  );
}

function logout(data) {
  return dispatch => (
    dispatch({
      type: 'LOGOUT',
      payload: API.logout(data.userId),
    }).then(res => {
      const { from } = data;
      const params = from ? JSON.parse(from) : {};
      delete params.userId;
      dispatch(
        ReduxRouter.push({ pathname: URL.getPath(params), state: params })
      );
      return res;
    })
  );
}

function requestPasswordReset(data) {
  return {
    type: 'REQUEST_PASSWORD_RESET',
    payload: API.requestPasswordReset(data),
  };
}

function sessionTimeout() {
  return { type: 'SESSION_TIMEOUT' };
}

function setUser(obj, timestamp) {
  return {
    type: 'SET_LOGGEDIN_USER',
    payload: {
      user: obj.user || obj || null,
      authenticationTime: obj.timestamp || timestamp,
    },
  };
}

function signup(data) {
  return {
    type: 'SIGNUP',
    payload: API.signup(data),
  };
}

module.exports = {
  changePassword,
  login,
  logout,
  requestPasswordReset,
  sessionTimeout,
  setUser,
  signup,
};
