const Redux = require('redux');
const promiseMiddleware = require('redux-promise-middleware').default;
const thunkMiddleware = require('redux-thunk').default;
const Router = require('react-router');
const ReduxRouter = require('react-router-redux');

const actions = require('./actions/appActions.js');
const routes = require('./views/routes.js');

const reducer = Redux.combineReducers({
  appState: require('./reducers/appReducer.js'),
  articleState: require('./reducers/articleReducer.js'),
  localeState: require('./reducers/localeReducer.js'),
  loginState: require('./reducers/loginReducer.js'),
  routing: ReduxRouter.routerReducer,
});

const isBrowser = typeof window == 'object';
const hasDevTools = isBrowser && typeof window.devToolsExtension != 'undefined';

function createStore(_history, data) {
  const store = Redux.compose(
    Redux.applyMiddleware(
      promiseMiddleware(),
      thunkMiddleware,
      ReduxRouter.routerMiddleware(_history)
    ),
    hasDevTools ? window.devToolsExtension() : (x => x)
  )(Redux.createStore)(reducer);
  if (data) {
    store.dispatch(actions.init(data));
  }
  const history = ReduxRouter.syncHistoryWithStore(_history, store);
  return { history, store };
}

module.exports = createStore;
