const ReactRouter = require('react-router');
const ReduxRouter = require('react-router-redux');

const actions = require('../src/scripts/actions/appActions.js');
const createStore = require('../src/scripts/store.coffee');
const negotiateLang = require('./negotiateLang.js');
const routes = require('../src/scripts/views/routes.js');
const URL = require('../src/node_modules/urlHelpers.js');

function createRouterHandler(propsHandler) {
  return function routerHandler(req, res) {
    const url = req.originalUrl;
    const config = {
      routes: routes,
      location: url,
      history: ReactRouter.createMemoryHistory(),
    };

    ReactRouter.match(config, (err, redirectLocation, props) => {
      if (err) {
        return res.status(500).send(err.message);
      }
      if (redirectLocation) {
        const { pathname, search } = redirectLocation;
        return res.redirect(302, pathname + search);
      }
      const lang = negotiateLang(req);
      const params = URL.getParams(props.params);
      const serverUrl = URL.getServerUrl(req);
      const storeModule = createStore(props.router);
      const { store } = storeModule;
      store.dispatch(actions.setCurrentParams(params));
      return propsHandler(
        req, res, { lang, params, props, serverUrl, storeModule }
      );
    });
  };
}

module.exports = createRouterHandler;
