const { createFactory, elements } = require('react-elementary').default;

const Output = createFactory(require('./output.coffee'));

const { span } = elements;

function FormMessage({ localeStrings, type, value }) {
  if (value) {
    return Output({ label: localeStrings[type], value: localeStrings[value] });
  }
  return span();
}

module.exports = FormMessage;
