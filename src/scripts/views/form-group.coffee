React = require 'react'
Elements = require '../elements.coffee'
{ label, div } = Elements

module.exports = React.createClass
	displayName: 'FormGroup'
	render: ->
		childTypes = []
		hasTextChild = false
		React.Children.forEach @props.children, (child) ->
			type = typeof child
			childTypes[childTypes.length] = type
			if type == 'string'
				hasTextChild = true
		props =
			className: 'form-group'
		unless childTypes[0] == 'string'
			props.className += '--unlabeled'
		for own k, v of @props
			props[k] = v
		if hasTextChild
			label props
		else
			div props