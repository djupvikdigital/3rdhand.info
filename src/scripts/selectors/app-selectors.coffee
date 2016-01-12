Reselect = require 'reselect'
Immutable = require 'immutable'
{ compose } = require 'transducers.js'

utils = require '../utils.coffee'
URL = require '../url.coffee'

{ argsToObject, prop } = utils

localeSelector = compose(
	(state) ->
		lang = state.get 'lang'
		return state.getIn([ 'localeStrings', lang ]).toJS()
	prop 'localeState'
)

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

titleSelector = Reselect.createSelector [ localeSelector ], (localeStrings) ->
	return {
		title: localeStrings.title || ''
	}

paramSelector = (state) ->
	Object.assign {}, state.routing.state

menuSelector = Reselect.createSelector(
	[ compose(prop('SiteMenu'), localeSelector), loginSelector, paramSelector ]
	argsToObject 'localeStrings', 'login', 'params'
)

module.exports =
	langPickerSelector: Reselect.createSelector(
		[ paramSelector, compose(prop('LangPicker'), localeSelector) ]
		argsToObject 'params', 'localeStrings'
	)
	linkSelector: (state, props) ->
		params = Immutable.Map state.routing.state
			.filter utils.keyIn 'userId', 'lang'
			.set 'slug', props.slug
			.merge props.params
			.update 'lang', (v) ->
				props.langParam || v
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
		[ compose(prop('SignupDialog'), localeSelector) ]
		argsToObject 'localeStrings'
	)
	titleSelector: titleSelector