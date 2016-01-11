React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

articleSelectors = require '../selectors/article-selectors.coffee'
appSelectors = require '../selectors/app-selectors.coffee'

{ loginSelector, signupSelector } = appSelectors

App = require './app.coffee'
authenticate = require './authenticate.coffee'

ArticleContainer = ReactRedux.connect(
	articleSelectors.containerSelector
)(require './article-container.coffee')
LoginDialog = ReactRedux.connect(loginSelector)(require './login-dialog.coffee')
SignupDialog = ReactRedux.connect(signupSelector)(
	require './signup-dialog.coffee'
)
AuthenticatedArticleContainer = ReactRedux.connect(loginSelector)(
	authenticate ArticleContainer
)

Route = React.createFactory Router.Route
IndexRoute = React.createFactory Router.IndexRoute
Redirect = React.createFactory Router.Redirect

module.exports = Route(
	path: '/', component: App
	IndexRoute component: ArticleContainer
	Route path: '(*/)login', component: LoginDialog
	Route path: 'signup', component: SignupDialog
	Route path: '/locales/:file', component: App
	Redirect from: 'users/:userId/logout', to: '/'
	Route path: 'users/:userId', component: AuthenticatedArticleContainer
	Route path: 'users/:userId/*', component: AuthenticatedArticleContainer
	Route path: '*', component: ArticleContainer
)
