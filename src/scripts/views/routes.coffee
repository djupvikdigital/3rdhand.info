React = require 'react'
Router = require 'react-router'
ReactRedux = require 'react-redux'

articleSelectors = require '../selectors/article-selectors.coffee'
appSelectors = require '../selectors/app-selectors.coffee'

{ loginSelector, signupSelector } = appSelectors

App = require './app.coffee'
ArticleContainer = ReactRedux.connect(
	articleSelectors.containerSelector
)(require './article-container.coffee')
LoginDialog = ReactRedux.connect(loginSelector)(require './login-dialog.coffee')
SignupDialog = ReactRedux.connect(signupSelector)(
	require './signup-dialog.coffee'
)

Route = React.createFactory Router.Route
IndexRoute = React.createFactory Router.IndexRoute

module.exports = Route(
	path: '/', component: App
	IndexRoute component: ArticleContainer
	Route path: 'admin', component: LoginDialog
	Route path: 'signup', component: SignupDialog
	Route path: '/locales/:file', component: App
	Route path: '*', component: ArticleContainer
)
