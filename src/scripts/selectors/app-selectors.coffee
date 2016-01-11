Reselect = require 'reselect'
Immutable = require 'immutable'

utils = require '../utils.coffee'
URL = require '../url.coffee'

localeSelector = (state) ->
	state = state.localeState
	return state.toJS()

loginSelector = (state) ->
	params = Immutable.Map(state.routing.state).delete 'view'
	state = state.loginState.toJS()
	if state.user
		return {
			isLoggedIn: true
			user: state.user
			authenticationTime: state.authenticationTime
			params: params.delete('userId').toJS()
		}
	else
		return {
			isLoggedIn: false
			params: params.toJS()
		}

titleSelector = Reselect.createSelector [ localeSelector ], (localeState) ->
	return {
		title: localeState.localeStrings.title || ''
	}

paramSelector = (state) ->
	Object.assign {}, state.routing.state

menuSelector = Reselect.createSelector(
	[ localeSelector, loginSelector, paramSelector ]
	(localeState, login, params) ->
		return {
			login: login
			localeStrings: localeState.localeStrings.SiteMenu
			params: params
		}
)

module.exports =
	langPickerSelector: (state) ->
		return {
			params: Object.assign {}, state.routing.state
			localeStrings: state.localeState.toJS().localeStrings.LangPicker
		}
	linkSelector: (state, props) ->
		params = Immutable.Map state.routing.state
			.filter utils.keyIn 'userId', 'lang'
			.set 'slug', props.slug
			.update 'lang', (v) ->
				props.langParam || v
			.merge props.params
			.toJS()
		return state: params, to: URL.getPath params
	localeSelector: localeSelector
	loginSelector: Reselect.createSelector(
		[ loginSelector, localeSelector ]
		(state, localeState) ->
			state.localeStrings = localeState.localeStrings.LoginDialog
			state
	)
	menuSelector: menuSelector
	paramSelector: paramSelector
	signupSelector: Reselect.createSelector(
		[ localeSelector ]
		(state) ->
			localeStrings: state.localeStrings.SignupDialog
	)
	titleSelector: titleSelector