jest.autoMockOff()

React = require 'react/addons'
TestUtils = React.addons.TestUtils
Elements = require 'react-coffee-elements'
FormGroup = React.createFactory require '../src/scripts/views/form-group.coffee'

{ input } = Elements
shallowRenderer = TestUtils.createRenderer()

describe 'FormGroup', ->
	it 'can render', ->
		shallowRenderer.render(
			FormGroup(
				'Test'
				input(type: 'text')
			)
		)
		output = shallowRenderer.getRenderOutput()
		expect(typeof output).toEqual('object')