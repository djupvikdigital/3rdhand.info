const { createFactory, elements } = require('react-elementary').default;

const ArticleItem = createFactory(require('./ArticleItem.js'));

const { article, div } = elements;

function ArticleList(props) {
  return div(
    props.articles.map(
      item => article({ key: item._id }, ArticleItem({ article: item }))
    )
  );
}

module.exports = ArticleList;
