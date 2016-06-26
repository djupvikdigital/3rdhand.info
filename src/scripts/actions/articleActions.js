const API = require('api');

function fetch(params) {
  return {
    type: 'FETCH_ARTICLES',
    payload: {
      promise: API.fetchArticles(params),
      data: { params },
    },
  };
}

function save(article, userId) {
  return {
    type: 'SAVE_ARTICLE',
    payload: {
      promise: API.saveArticle(article, userId),
      data: { article },
    },
  };
}

module.exports = { fetch, save };
