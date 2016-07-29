const Redux = require('redux');
const promiseMiddleware = require('redux-promise-middleware');
const thunkMiddleware = require('redux-thunk').default;
const ReduxRouter = require('react-router-redux');

const actions = require('./actions/appActions.js');

const appState = require('./reducers/appReducer.js');
const articleState = require('./reducers/articleReducer.js');
const localeState = require('./reducers/localeReducer.js');
const loginState = require('./reducers/loginReducer.js');

const routing = ReduxRouter.routerReducer;

const reducer = Redux.combineReducers({
  appState, articleState, localeState, loginState, routing,
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
