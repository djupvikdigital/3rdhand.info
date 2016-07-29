const { createFactory } = require('react');
const Router = require('react-router');
const { connect } = require('react-redux');

const { changePasswordSelector, loginSelector, signupSelector } = require(
  '../selectors/appSelectors.js'
);
const { containerSelector } = require('../selectors/articleSelectors.js');

const App = require('./App.js');
const authenticate = require('./authenticate.js');

const ArticleContainer = connect(containerSelector)(
  require('./ArticleContainer.js')
);

const AuthenticatedArticleContainer = connect(loginSelector)(
  authenticate(ArticleContainer)
);
const ChangePasswordDialog = connect(changePasswordSelector)(
  authenticate(require('./ChangePasswordDialog.js'))
);
const LoginDialog = connect(loginSelector)(require('./LoginDialog.js'));
const SignupDialog = connect(signupSelector)(require('./SignupDialog.js'));

const IndexRoute = createFactory(Router.IndexRoute);
const Route = createFactory(Router.Route);

const routes = Route(
  { path: '/', component: App },
  IndexRoute({ component: ArticleContainer }),
  Route({ path: '(*/)login', component: LoginDialog }),
  Route({ path: 'signup', component: SignupDialog }),
  Route({ path: '/locales/:file', component: App }),
  Route({
    path: 'users/:userId/change-password', component: ChangePasswordDialog,
  }),
  Route({ path: 'users/:userId/logout', component: LoginDialog }),
  Route({ path: 'users/:userId', component: AuthenticatedArticleContainer }),
  Route({ path: 'users/:userId/*', component: AuthenticatedArticleContainer }),
  Route({ path: '*', component: ArticleContainer })
);

module.exports = routes;
