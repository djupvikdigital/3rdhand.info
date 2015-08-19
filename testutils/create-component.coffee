React = require 'react/addons'

TestUtils = React.addons.TestUtils

module.exports = (component, props, children...) ->
	shallowRenderer = TestUtils.createRenderer()
	shallowRenderer.render(
		React.createElement(
			component, props, (if children.length > 1 then children else children[0])
		)
	)
	shallowRenderer.getRenderOutput()
