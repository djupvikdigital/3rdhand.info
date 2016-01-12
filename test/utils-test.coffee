expect = require 'expect'

Immutable = require 'immutable'
t = require 'transducers.js'

formatters = require '../src/scripts/formatters.coffee'
utils = require '../src/scripts/utils.coffee'

describe 'utils module', ->
	describe 'array', ->
		it 'converts non-arrays to array', ->
			test = [ 'item1', 'item2' ]
			expect(utils.array('item1', 'item2')).toEqual test
		it 'leaves an array alone', ->
			input = [ 'item1', 'item2' ]
			expect(utils.array input).toEqual input

	describe 'createFormatMapper', ->
		it 'returns text formatted from a format and a text', ->
			format = 'markdown'
			text = 'Markdown *em*.'
			test = '<p>Markdown <em>em</em>.</p>\n'
			expect(utils.createFormatMapper(formatters)(format, text)).toEqual test
		it 'returns just the text if there are now formatters', ->
			format = 'markdown'
			text = 'Markdown *em*.'
			expect(utils.createFormatMapper()(format, text)).toEqual text

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

	describe 'mapObjectRecursively', ->
		it 'takes mapper functions and goes over the object recursively, applying to objects with provided props', ->
			input =
				foo:
					bar: 1
				baz: [
					{ foo: 1, bar: 2 }
					{ foo: 1, baz: 1 }
				]
			test =
				foo: 2
				baz: [
					3
					{ foo: 1, baz: 1 }
				]
			mapper1 = (foo, bar) ->
				foo + bar
			mapper2 = (bar) ->
				bar + 1
			args = [
				input
				[ 'foo', 'bar', mapper1 ]
				[ 'bar', mapper2 ]
			]
			expect(utils.mapObjectRecursively.apply(null, args)).toEqual test

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

	describe 'zip', ->
		it 'zips arrays', ->
			input = [
				[ 'foo', 'bar', 'baz' ]
				[ 1, 2, 3 ]
				[ 'oof', 'rab', 'zab' ]
			]
			test = [
				[ 'foo', 1, 'oof' ]
				[ 'bar', 2, 'rab' ]
				[ 'baz', 3, 'zab' ]
			]
			expect(utils.zip input).toEqual test
