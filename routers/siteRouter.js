const router = require('express').Router();
const ReactRouter = require('react-router');
const ReduxRouter = require('react-router-redux');

const API = require('../src/node_modules/api.js');
const createHandler = require('../lib/createRouterHandler.js');
const createStore = require('../src/scripts/store.coffee');
const logger = require('../lib/log.js');
const negotiateLang = require('../lib/negotiateLang.js');
const renderTemplate = require('../lib/render-template.coffee');
const URL = require('../src/node_modules/url-helpers.coffee');
const userActions = require('../src/scripts/actions/user-actions.coffee');
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
  res.format({
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
      API.fetchArticles(params)
        .then(res.send.bind(res))
        .catch(err => {
          logger.error(err);
          res.sendStatus(500);
        });
    },
  });
}));

module.exports = router;
