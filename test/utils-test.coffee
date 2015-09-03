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

describe 'filterValueAndKey', ->
	it 'returns an object filtered by key', ->
		input =
			bar: 2
			foo: 1
			baz: 0
		test =
			baz: 0
			bar: 2
		output = t.seq input, utils.filterValueAndKey utils.keyIn 'bar', 'baz'
		expect(output).toEqual test

describe 'getFirstValue', ->
	it 'returns the first value from a list of keys that is not falsy', ->
		input =
			bar: 0
			foo: 1
			baz: 2
		expect(utils.getFirstValue(input, 'bar', 'baz')).toBe 2
# 	it 'returns the last value from the keys if no values are not falsy', ->
# 		input =
# 			foo: 1
# 			bar: 0
# 			baz: ''
# 		expect(utils.getFirstValue(input, 'bar', 'baz')).toBe ''

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
