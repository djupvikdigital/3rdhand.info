const session = require('cookie-session');
const router = require('express').Router();
const YAML = require('js-yaml');
const moment = require('moment');
const createHistory = require('react-router').createMemoryHistory;
const URL = require('url');

const articleActions = require('../src/scripts/actions/article-actions.coffee');
const API = require('../src/node_modules/api.js');
const createStore = require('../src/scripts/store.coffee');
const DB = require('../lib/db.js');
const handleError = require('../lib/handleError.js');
const siteRouter = require('./siteRouter.js');
const userActions = require('../src/scripts/actions/user-actions.coffee');
const { getPath, getUserPath, getServerUrl } = require(
  '../src/node_modules/urlHelpers.js'
);
const utils = require('../lib/utils.js');

const conf = YAML.safeLoad(utils.read('./config.yaml'));

function clearUserSession(req) {
  if (!req) {
    throw new Error('missing required argument');
  }
  if (req.session) {
    req.session = null;
  }
}

router.use(
  session({ name: 'session', secret: conf.serverSecret, httpOnly: true})
);

router.post('/', (req, res) => {
  const data = req.body;
  if (data.resetPassword) {
    return API.requestPasswordReset(data, getServerUrl(req))
      .then(res.send.bind(res))
      .catch(handleError.bind(null, res));
  }
  const { store } = createStore(createHistory());
  store.dispatch(userActions.login(data))
    .then(({ action, value }) => {
      const { user, timestamp } = value;
      if (action.error) {
        return Promise.reject(value);
      }
      req.session.user = user;
      req.session.timestamp = timestamp;
      return res.format({
        html() {
          return res.redirect(303, getUserPath(user._id + data.from));
        },
        default() {
          return res.send(value);
        },
      });
    }).catch(handleError.bind(null, res));
});

router.use('/:userId', (req, res, next) => {
  let data = Object.assign({}, req.query, req.body, req.params);
  if (data.token && data.timestamp) {
    data = Object.assign({}, data, { path: req.baseUrl + req.path });
    return DB.authenticate(data)
      .then(user => {
        req.user = user;
        return next();
      }).catch(next);
  }
  let duration;
  let timestamp = 0;
  if (req.session && req.session.timestamp) {
    timestamp = req.session.timestamp;
    duration = moment.duration(Date.now() - timestamp);
  }
  if (!timestamp || duration.asMinutes() > 30) {
    // session timed out
    clearUserSession(req);
    return next(new Error('session timeout'));
  }
  req.session.timestamp = Date.now();
  return next();
});

router.get('/:userId/logout', (req, res) => {
  clearUserSession(req);
  return res.format({
    html() {
      let path = '/';
      if (req.query.from) {
        const from = JSON.parse(req.query.from);
        delete from.userId;
        path = getPath(from);
      }
      else {
        let url;
        const referrer = req.get('Referer');
        if (referrer) {
          url = URL.parse(referrer);
        }
        if (url && url.hostname === req.hostname) {
          path = url.path;
        }
      }
      res.redirect(303, getServerUrl(req) + path);
    },
    default() {
      res.status(204).end();
    },
  });
});

router.post('/:userId', (req, res) => {
  const data = req.body;
  if (data.changePassword) {
    return API.changePassword(req.params.userId, data)
      .then(res.send.bind(res))
      .catch(handleError.bind(null, res));
  }
  const { store } = createStore(createHistory());
  return store.dispatch(articleActions.save(data, req.session.user._id))
    .then(res.send.bind(res))
    .catch(handleError.bind(null, res));
});

router.use('/:userId', siteRouter);

module.exports = router;
