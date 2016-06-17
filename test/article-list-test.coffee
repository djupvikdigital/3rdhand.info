expect = require 'expect'

React = require 'react'
ReactDOM = require 'react-dom/server'
ReactRedux = require 'react-redux'
{ createMemoryHistory } = require 'react-router'
cheerio = require 'cheerio'

createFactory = require '../src/scripts/create-factory.coffee'

createStore = require '../src/scripts/store.coffee'
selectors = require '../src/scripts/selectors/article-selectors.coffee'
ArticleList = createFactory require '../src/scripts/views/article-list.coffee'

Provider = createFactory ReactRedux.Provider

describe 'ArticleList', ->
  it 'renders a list of articles', ->
    { store } = createStore createMemoryHistory()
    articles = [
      {
        _id: '_id1'
        published: { utc: '2016-02-07T19:54:00Z', timezone: 'UTC' }
      }
      {
        _id: '_id2'
        published: { utc: '2016-02-07T19:55:00Z', timezone: 'UTC' }
      }
    ]
    store.dispatch
      type: 'FETCH_ARTICLES_FULFILLED'
      payload:
        docs: articles
    props = selectors.containerSelector(store.getState())
    component = Provider(
      store: store
      ArticleList props
    )
    html = ReactDOM.renderToStaticMarkup component
    $ = cheerio.load html
    articles = $ 'article'
    expect(articles.length).toBe 2
