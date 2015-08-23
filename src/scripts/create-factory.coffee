React = require 'react'

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
		if !options.length or React.isValidElement(options[0]) or options[0].constructor isnt Object
			options.unshift {}
		else
			options[0] = transformProps options[0]
		options.unshift ReactClass
		React.createElement options...