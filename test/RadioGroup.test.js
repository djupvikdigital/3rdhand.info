const expect = require('expect');

const cheerio = require('cheerio');
const ReactDOM = require('react-dom/server');
const { createFactory } = require('react-elementary').default;

const RadioGroup = createFactory(require('../src/scripts/views/RadioGroup.js'));
const RadioOption = createFactory(require('../src/scripts/views/RadioOption.js'));

describe('RadioGroup', () => {
  it('renders RadioOptions children with the same name', () => {
    const component = RadioGroup(
      { name: 'test' },
      RadioOption({ label: 'foo', value: 'foo' }),
      RadioOption({ label: 'bar', value: 'bar' })
    );
    const html = ReactDOM.renderToStaticMarkup(component);
    const $ = cheerio.load(html);
    const radios = $('input[type="radio"]');
    expect(radios.length).toBe(2);
    radios.each((i, el) => {
      expect(el.attribs.name).toBe('test');
    });
  });
});
