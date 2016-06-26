const API = require('api');

function fetchStrings(lang) {
  if (!lang) {
    throw new Error('lang parameter missing');
  }
  return {
    type: 'FETCH_LOCALE_STRINGS',
    payload: {
      promise: API.fetchLocaleStrings(lang),
      data: { lang },
    },
  };
}

module.exports = { fetchStrings };
