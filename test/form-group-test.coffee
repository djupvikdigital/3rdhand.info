expect = require 'expect'

React = require 'react'
ReactDOM = require 'react-dom/server'
cheerio = require 'cheerio'

Elements = require '../src/scripts/elements.coffee'
FormGroup = React.createFactory require '../src/scripts/views/form-group.coffee'

{ input } = Elements

describe 'FormGroup', ->
	it 'can render', ->
		component = FormGroup(
			'Test'
			input type: 'text'
		)
		$ = cheerio.load ReactDOM.renderToStaticMarkup component
		expect($('input').length).toBe 1