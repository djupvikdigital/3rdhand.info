const merge = require('ramda/src/merge');
const { createFactory, elements } = require('react-elementary').default;
const { connect } = require('react-redux');
const Router = require('react-router');

const { linkSelector } = require('../selectors/appSelectors.js');

const Link = createFactory(connect(linkSelector)(Router.Link));

const { footer } = elements;

function ArticleFooter({ article, localeStrings, login }) {
  const children = [];
  const { edit } = localeStrings;
  const { urlParams } = article;
  if (login.isLoggedIn) {
    children.push(Link({ params: merge(urlParams, { view: 'edit' }) }, edit));
  }
  return footer(...children);
}

module.exports = ArticleFooter;
