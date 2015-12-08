Reselect = require 'reselect'
Immutable = require 'immutable'

URL = require '../url.coffee'

localeSelector = (state) ->
	state = state.localeState
	return state.toJS()

loginSelector = (state) ->
	state = state.loginState.toJS()
	if state.user
		return {
			isLoggedIn: true
			user: state.user
		}
	else
		return {
			isLoggedIn: false
		}

titleSelector = Reselect.createSelector [ localeSelector ], (localeState) ->
	return {
		title: localeState.localeStrings.title || ''
	}

menuSelector = Reselect.createSelector(
	[localeSelector, loginSelector]
	(localeState, login) ->
		return {
			login: login
			localeStrings: localeState.localeStrings.SiteMenu
		}
)

routeSelector = (state) ->
	routerState: state.router

module.exports =
	langPickerSelector: (state) ->
		return {
			localeStrings: state.localeState.toJS().localeStrings.LangPicker
		}
	linkSelector: Reselect.createSelector(
		[ loginSelector, routeSelector ]
		(login, state) ->
			linkState = Immutable.fromJS state.routerState
			linkState.set('login', login).toJS()
	)
	localeSelector: localeSelector
	loginSelector: Reselect.createSelector(
		[ loginSelector, localeSelector ]
		(state, localeState) ->
			state.localeStrings = localeState.localeStrings.LoginDialog
			state
	)
	menuSelector: menuSelector
	paramSelector: URL.getParamsFromRouterState
	routeSelector: routeSelector
	signupSelector: Reselect.createSelector(
		[ localeSelector ]
		(state) ->
			localeStrings: state.localeStrings.SignupDialog
	)
	titleSelector: titleSelector