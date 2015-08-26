module.exports = (state) ->
	state = state.localeState
	return state.get('localeStrings').toObject()