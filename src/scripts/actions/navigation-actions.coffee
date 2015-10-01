module.exports =
	setParams: (params) ->
		return {
			type: 'SET_PARAMS'
			params: params
		}