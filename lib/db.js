const path = require('path');

const Promise = require('bluebird');
const cuid = require('cuid');
const moment = require('moment');
const PouchDB = require('pouchdb');
PouchDB.plugin(require('pouchdb-upsert'));
const R = require('ramda');
const t = require('transducers.js');

const Crypto = require('./crypto.js');
const ddoc = require('./ddoc.js');
const logger = require('./log.js');
const URL = require('../src/web_modules/url-helpers.coffee');
const utils = require('../src/scripts/utils.coffee');

function allHandler(query) {
  query.include_docs = true;
  return db.allDocs(query).then(defaultTransform);
}

function authenticateByPassword(userPromise, { password }) {
  return userPromise.then(user => (
    Crypto.compare(password, user.password_hash).then(onAuthenticate(user))
  ));
}

function authenticateByToken(userPromise, { timestamp, token }) {
  if (moment.duration(Date.now() - timestamp).asMinutes() > 60) {
    throw new Error('token expired');
  }
  return userPromise.then(user => {
    const path = `${URL.getUserPath(user._id)}/change-password`;
    const arr = [user.password_hash, path, timestamp];
    return Crypto.verify(arr, token).then(onAuthenticate(user));
  });
}

function defaultTransform(body) {
  return body.rows.map(getDocFromRow);
}

function defaultViewHandler(view, query) {
  query.include_docs = true;
  return db.query(`app/${view}`, query).then(defaultTransform);
}

function diff() {
  return ddoc;
}

function getDocFromRow(row) {
  return row.doc;
}

function getQueryProps(query) {
  const props = ['key', 'startkey', 'endkey', 'descending'];
  return R.pick(props, query);
}

function getUserId() {
  return `user/${cuid()}`;
}

function onAuthenticate(user) {
  return success => {
    if (!success) {
      return Promise.reject(new Error('authentication failed'));
    }
    return user;
  };
}

const db = new PouchDB(path.resolve(__dirname, '../db/thirdhandinfo'));

// Public API

function addUser(data) {
  const { password, repeatPassword } = data;
  if (!data || password !== repeatPassword) {
    throw new Error('repeat password mismatch');
  }
  return isSignupAllowed()
    .then(isAllowed => {
      if (!isAllowed) {
        const error = new Error('permission denied');
        error.status = 403;
        throw error;
      }
      return true;
    })
    .then(() => Crypto.hash(password))
    .then(hash => db.put({
      _id: getUserId(),
      type: 'user',
      email: email,
      password_hash: hash,
      roles: ['write'],
    }));
}

function authenticate(data) {
  const { email, password, timestamp, token, userId } = data;
  let userPromise;
  if (email) {
    userPromise = viewHandlers.by_email({ key: ['user', email] });
  }
  else if (userId) {
    userPromise = allHandler({ key: `user/${userId}` }).then(R.prop(0));
  }
  else {
    return Promise.reject(new Error('required fields missing'));
  }
  let fn;
  if (password) {
    fn = authenticateByPassword;
  }
  else if (token && timestamp) {
    fn = authenticateByToken;
  }
  else {
    return Promise.reject(new Error('authentication failed'));
  }
  return fn(userPromise, data).catch(err => {
    console.log(err);
    let error = err;
    if (err.status === 404) {
      logger.warn('Invalid login attempt');
      error = new Error('authentication failed');
      error.status = 401;
    }
    throw error;
  });
}

function changePassword(data) {
  const { newPassword, repeatPassword, userId } = data;
  if (!newPassword || !userId) {
    return Promise.reject(new Error('required fields missing'));
  }
  if (newPassword !== repeatPassword) {
    return Promise.reject(new Error('repeat password mismatch'));
  }
  return authenticate(data).then(user => {
    return Crypto.hash(newPassword).then(hash => {
      user.password_hash = hash;
      return db.put(user);
    });
  });
}

function get(arg1) {
  const view = arguments.length === 2 ? arg1 : '';
  const query = getQueryProps(arguments[arguments.length - 1]);
  if (!view) {
    return allHandler(query);
  }
  if (typeof viewHandlers[view] == 'function') {
    return viewHandlers[view](query);
  }
  return defaultViewHandler(view, query);
}

function isSignupAllowed() {
  // only one user allowed - TODO: make configurable
  return get({ startkey: 'user', endkey: 'user\uffff' })
    .then(users => !users.length);
}

function put(userId, doc) {
  if (!userId) {
    return Promise.reject(new Error('login required'));
  }
  return db.get(userId).then(user => {
    if (R.contains('write', user.roles)) {
      return db.put(doc);
    }
    else {
      return Promise.reject(new Error('permission denied'));
    }
  });
}

module.exports = {
  addUser, authenticate, changePassword, get, isSignupAllowed, put
};
