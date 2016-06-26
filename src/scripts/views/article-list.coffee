Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'

selectors = require '../selectors/articleSelectors.js'
ArticleItem = createFactory require './ArticleItem.js'

{ article, div } = Elements

module.exports = (props) ->
  div props.articles.map (item) ->
    article { key: item._id }, ArticleItem article: item

module.exports.displayName = 'ArticleList'
