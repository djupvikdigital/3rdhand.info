const Router = require('react-router');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary').default;

const { footerSelector } = require('../selectors/articleSelectors.js');
const { linkSelector } = require('../selectors/appSelectors.js');

const ArticleFooter = createFactory(
  connect(footerSelector)(require('./ArticleFooter.js'))
);

const Link = createFactory(connect(linkSelector)(Router.Link));

const { div, header, h1, time } = elements;

function ArticleItem({ article }) {
  const {
    headline, published, publishedFormatted, summary, title, urlParams,
  } = article;
  const headerChildren = [
    h1(
      { className: 'article__heading' },
      Link({ params: urlParams, innerHtml: headline || title })
    ),
  ];
  if (published && published.utc) {
    headerChildren.push(
      time({ className: 'milli', dateTime: published.utc }, publishedFormatted)
    );
  }
  return div(
    header(...headerChildren),
    div({ innerHtml: summary }),
    ArticleFooter({ article })
  );
}

module.exports = ArticleItem;
