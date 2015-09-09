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

describe 'getProps', ->
	it 'returns an object with only the props in the provided array of keys', ->
		input =
			foo: 0
			bar: 1
			baz: 2
		test =
			foo: 0
			bar: 1
		expect(utils.getProps(input, ['foo', 'bar'])).toEqual test

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
	it 'supports mapping arrays', ->
		input = [
			field:
				nb: 'felt1'
				en: 'field1'
			field:
				nb: 'felt2'
				en: 'field2'
		]
		test = [
			field: 'felt1'
			field: 'felt2'
		]
		expect(utils.localize('nb', input)).toEqual test

describe 'mapObjectRecursively', ->
	it 'takes a mapper function and goes over the object recursively, applying to objects with provided props', ->
		input =
			foo:
				bar: 1
			baz: [
				{ foo: 1, bar: 2 }
				{ foo: 1, baz: 1 }
			]
		test =
			foo:
				bar: 1
			baz: [
				3
				{ foo: 1, baz: 1 }
			]
		mapper = (foo, bar) ->
			foo + bar
		expect(utils.mapObjectRecursively(input, [ 'foo', 'bar' ], mapper)).toEqual test

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
