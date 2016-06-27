require('es6-promise').polyfill();
const assign = require('object-assign');
const React = require('react');
const ReactDOM = require('react-dom');
const ReactRouter = require('react-router');
const ReduxRouter = require('react-router-redux');
const { createFactory } = require('react-elementary').default;
const { XmlEntities } = require('html-entities');

const appActions = require('./actions/appActions.js');
const createStore = require('./store.coffee');
const init = require('./init.js');
const routes = require('./views/routes.js');
const URL = require('urlHelpers');
const userActions = require('./actions/userActions.js');

const Root = createFactory(require('./views/Root.js'));

const Router = createFactory(ReactRouter.Router);

Object.assign || (Object.assign = assign);

const entities = new XmlEntities();
const serverState = document.getElementById('state').textContent;
const data = JSON.parse(entities.decode(serverState));
const serverUrl = URL.getServerUrl();

const { store, history } = createStore(ReactRouter.browserHistory, data);

history.listen(({ pathname }) => {
  const state = store.getState().appState.toJS();
  if (URL.getPath(state.currentParams) !== pathname) {
    const params = state.urlsToParams[pathname] || {};
    store.dispatch(appActions.setCurrentParams(params));
  }
});

const { currentParams } = store.getState().appState.toJS();

init(store, currentParams, document.documentElement.lang).then(() => (
  ReactDOM.render(
    Root({ store }, Router({ history }, routes)),
    document.getElementById('app')
  )
)).catch(err => {
  console.error(err.stack || err);
});
