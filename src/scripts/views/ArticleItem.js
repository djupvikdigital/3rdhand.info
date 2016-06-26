const React = require('react');
const Router = require('react-router');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary').default;

const { linkSelector } = require('../selectors/appSelectors.js');

const Link = createFactory(connect(linkSelector)(Router.Link));

const { div, header, h1, time } = elements;

function ArticleItem(props) {
  const {
    headline, published, publishedFormatted, summary, title, urlParams
  } = props.article;
  return div(
    header(
      h1(
        { className: 'article__heading' },
        Link({ params: urlParams, innerHtml: headline || title })
      ),
      time({ className: 'milli', dateTime: published.utc}, publishedFormatted)
    ),
    div({ innerHtml: summary })
  );
}

module.exports = ArticleItem;
