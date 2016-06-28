const expect = require('expect');

const cheerio = require('cheerio');
const ReactDOM = require('react-dom/server');
const { createFactory, elements } = require('react-elementary').default;

const FormGroup = createFactory(require('../src/scripts/views/FormGroup.js'));

const { input } = elements;

describe('FormGroup', () => {
  it ('can render', () => {
    const component = FormGroup('Test', input({ type: 'text '}))
    const $ = cheerio.load(ReactDOM.renderToStaticMarkup(component));
    expect($('input').length).toBe(1);
  });
});
