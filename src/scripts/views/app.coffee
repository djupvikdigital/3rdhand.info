ReactRedux = require 'react-redux'

createFactory = require '../create-factory.coffee'
selector = require('../selectors/app-selectors.coffee').menuSelector

Elements = require '../elements.coffee'
SiteMenu = createFactory(
	ReactRedux.connect(selector)(require './site-menu.coffee')
)

{ div } = Elements

module.exports = (props) ->
	div(
		SiteMenu()
		div(
			className: 'wrapper'
			props.children
		)
	)

module.exports.displayName = 'App'
