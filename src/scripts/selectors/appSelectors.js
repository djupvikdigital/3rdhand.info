const Immutable = require('immutable');
const omit = require('lodash/omit');
const Reselect = require('reselect');
const { compose } = require('transducers.js');

const URL = require('urlHelpers');
const utils = require('../utils.coffee');

const { argsToObject, prop } = utils;

const localeSelector = compose(
  state => state.getIn(['localeStrings', state.get('lang')]).toJS(),
  prop('localeState')
);

function loginSelector(_state) {
  const params = omit(_state.appState.toJS().currentParams, 'view');
  const state = _state.loginState.toJS();
  if (state.user) {
    return {
      isLoggedIn: true,
      user: state.user,
      authenticationTime: state.authenticationTime,
      params: omit(params, 'userId'),
    };
  }
  return {
    isLoggedIn: false,
    params: params,
  };
}

const titleSelector = Reselect.createSelector(
  [localeSelector],
  localeStrings => ({ title: localeStrings.title || '' })
);

function paramSelector(state) {
  return state.appState.toJS().currentParams;
}

const headerSelector = Reselect.createSelector(
  [compose(prop('SiteHeader'), localeSelector), loginSelector, paramSelector],
  argsToObject('localeStrings', 'login', 'params')
);

// Public API

const changePasswordSelector = Reselect.createSelector(
  [paramSelector, loginSelector, localeSelector],
  (params, login, { ChangePasswordDialog, LoginDialog }) => {
    const localeStrings = Object.assign({}, ChangePasswordDialog, LoginDialog);
    return { localeStrings, login, params };
  }
)

const formMessageSelector = compose(
  argsToObject('localeStrings'), prop('FormMessage'), localeSelector
);

const langPickerSelector = Reselect.createSelector(
  [compose(prop('LangPicker'), localeSelector)], argsToObject('localeStrings')
);

function linkSelector(_state, props) {
  const state = _state.appState.toJS();
  const { currentParams } = state;
  const { langParam, page } = props;
  let params;
  if (page) {
    params = state.params[page];
  }
  else if (langParam) {
    params = Object.assign({}, currentParams, { lang: langParam });
  }
  params = URL.getNextParams(Object.assign({ currentParams, params }, props));
  return Object.assign(
    { to: { pathname: URL.getPath(params) }},
    omit(props, 'currentParams', 'langParam', 'params', 'slug')
  );
}

const signupSelector = Reselect.createSelector(
  [compose(prop('SignupDialog'), localeSelector)],
  argsToObject('localeStrings')
);

module.exports = {
  changePasswordSelector,
  formMessageSelector,
  headerSelector,
  langPickerSelector,
  linkSelector,
  localeSelector,
  loginSelector: Reselect.createSelector(
    [loginSelector, compose(prop('LoginDialog'), localeSelector)],
    argsToObject('login', 'localeStrings')
  ),
  paramSelector,
  signupSelector,
  titleSelector,
};