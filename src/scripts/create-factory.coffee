React = require 'react'

isProps = (obj) ->
	!React.isValidElement(obj) && obj.constructor == Object && !('_reactFragment' of obj)

transformProps = (props) ->
	res = {}
	for k, v of props
		if k == 'innerHtml'
			res.dangerouslySetInnerHTML = { __html: v }
		else
			res[k] = v
	return res

module.exports = (ReactClass) ->
	(options...) ->
		if Array.isArray options[options.length - 1]
			options = Array.prototype.concat.apply([], options)
		if !options.length || !options[0] || !isProps(options[0])
			options.unshift {}
		else
			options[0] = transformProps options[0]
		options.unshift ReactClass
		React.createElement options...