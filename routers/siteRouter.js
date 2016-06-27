const router = require('express').Router();
const ReactRouter = require('react-router');
const ReduxRouter = require('react-router-redux');

const API = require('../src/node_modules/api.js');
const createHandler = require('../lib/createRouterHandler.js');
const createStore = require('../src/scripts/store.js');
const logger = require('../lib/log.js');
const negotiateLang = require('../lib/negotiateLang.js');
const renderTemplate = require('../lib/renderTemplate.js');
const URL = require('../src/node_modules/urlHelpers.js');
const userActions = require('../src/scripts/actions/userActions.js');
const utils = require('../src/scripts/utils.coffee');

function setUser(session, userId, dispatch) {
  if (!userId) {
    return false;
  }
  const id = `user/${userId}`;
  if (session && session.user._id === id) {
    dispatch(userActions.setUser(utils.getUserProps(session.user)));
    return true;
  }
  return false;
}

router.get('*', createHandler((req, res, config) => {
  const { params, props, storeModule } = config;
  if (!props) {
    throw new Error('no route match');
  }
  return res.format({
    html() {
      const { store, history } = storeModule;
      if (req.user) {
        store.dispatch(userActions.setUser(utils.getUserProps(req.user)));
      }
      else {
        setUser(req.session, params.userId, store.dispatch);
      }
      return renderTemplate(config).then(res.send.bind(res));
    },
    default() {
      return API.fetchArticles(params)
        .then(res.send.bind(res))
        .catch(err => {
          logger.error(err);
          return res.sendStatus(500);
        });
    },
  });
}));

module.exports = router;
