expect = require 'expect'

ReactDOM = require 'react-dom/server'
cheerio = require 'cheerio'

createFactory = require '../src/scripts/create-factory.coffee'

RadioGroup = createFactory require '../src/scripts/views/radio-group.coffee'
RadioOption = createFactory require '../src/scripts/views/radio-option.coffee'

describe 'RadioGroup', ->
  it 'renders RadioOptions children with the same name', ->
    component = RadioGroup(
      name: 'test'
      RadioOption label: 'foo', value: 'foo'
      RadioOption label: 'bar', value: 'bar'
    )
    html = ReactDOM.renderToStaticMarkup component
    $ = cheerio.load html
    radios = $ 'input[type=radio]'
    expect(radios.length).toBe 2
    radios.each ->
      expect(this.attribs.name).toBe 'test'
