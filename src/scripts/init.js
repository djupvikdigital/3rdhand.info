const { fetch } = require('./actions/articleActions.js');
const { fetchStrings } = require('./actions/localeActions.js');

function init(store, params, lang) {
  return Promise.all([
    store.dispatch(fetchStrings(lang)),
    store.dispatch(fetch(params)),
  ]).catch(err => {
    console.error(err.stack || err);
  });
}

module.exports = init;
