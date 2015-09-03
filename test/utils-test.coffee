expect = require 'expect'

Immutable = require 'immutable'
t = require 'transducers.js'

formatters = require '../src/scripts/formatters.coffee'
utils = require '../src/scripts/utils.coffee'

describe 'format', ->
	it 'returns an object with field values formatted from a format subfield', ->
		input =
			field:
				format: 'markdown'
				text: 'Markdown *em*.'
		test =
			field: '<p>Markdown <em>em</em>.</p>\n'
		expect(utils.format(input, formatters)).toEqual test

describe 'getFieldValueFromFormats', ->
	it 'returns an object with field values from a format subfield', ->
		input =
			field:
				format: 'markdown'
				text: 'Markdown *em*.'
		test =
			field: 'Markdown *em*.'
		expect(utils.getFieldValueFromFormats(input)).toEqual test

describe 'localize', ->
	it 'returns an object with field values set to language subfields', ->
		input =
			field:
				nb: 'felt'
				en: 'field'
		test =
			field: 'felt'
		expect(utils.localize('nb', input)).toEqual test

	it 'returns a value from an object with toplevel fields having language keys', ->
		input =
			nb: 'felt'
			en: 'field'
		test = 'felt'
		expect(utils.localize('nb', input)).toBe 'felt'

describe 'stripDbFields', ->
	it 'removes fields _id and _rev from an object', ->
		input =
			_id: 'id'
			_rev: 'rev'
			field: 'field'
		test =
			field: 'field'
		expect(utils.stripDbFields(input)).toEqual test

	it 'returns an Immutable.Map if provided an Immutable.Map', ->
		input = Immutable.Map
			field: 'field'
		output = utils.stripDbFields input
		expect(Immutable.Map.isMap(output)).toBe true
