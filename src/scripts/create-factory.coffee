React = require 'react'

module.exports = (ReactClass) ->
	(options...) ->
		if !options.length or React.isValidElement(options[0]) or options[0].constructor isnt Object
			options.unshift {}
		options.unshift ReactClass
		React.createElement.apply this, options