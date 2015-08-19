React = require 'react'

createFactory = require './create-factory.coffee'

module.exports = (->
	elements = {}
	for element in Object.keys(React.DOM)
		elements[element] = createFactory(element)
	elements
)()