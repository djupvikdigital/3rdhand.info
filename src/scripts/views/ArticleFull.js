const React = require('react');
const { createFactory, elements } = require('react-elementary');

const Helmet = createFactory(require('react-helmet'));

const { formatSelector } = require('../selectors/articleSelectors.js');
const URL = require('urlHelpers');

const { b, div, header, h1, p } = elements;

function ArticleFull(props) {
  const { article, lang, serverUrl } = props;
  if (!article || !article.title[lang].text) {
    return div();
  }
  const {
    body, headline, intro, summary, title
  } = formatSelector(article, lang);
  const pageTitle = props.title || title;
  const description = article.summary[lang].text;
  const url = serverUrl + URL.getPath(article.urlParams);
  return div(
    Helmet({
      title: pageTitle,
      meta: [
        { name: 'description', content: description },
        { name: 'twitter:card', content: 'summary' },
        { name: 'twitter:site', content: '@thirdhandinfo' },
        { name: 'twitter:url', property: 'og:url', content: url },
        { name: 'twitter:title', property: 'og:title', content: pageTitle },
        {
          name: 'twitter:description',
          property: 'og:description',
          content: description,
        },
      ],
    }),
    h1({ innerHtml: headline || title }),
    intro ? p(b({ className: 'intro', innerHtml: intro })) : null,
    div({ innerHtml: body })
  );
}

module.exports = ArticleFull;
