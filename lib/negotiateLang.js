const accepts = require('accepts');

Lang = require('./lang.coffee');
URL = require('../src/node_modules/url-helpers.coffee');

const l = Lang.supportedLocales;

function negotiateLang(req) {
  const lang = URL.splitPath(req.url).filename.filter(Lang.isLanguage)[0];
  return Lang.negotiateLang(lang) || accepts(req).languages(l) || l[0];
}

module.exports = { negotiateLang };
