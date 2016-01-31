articleActions = require './actions/article-actions.coffee'
{ fetchStrings } = require './actions/locale-actions.coffee'

module.exports = (store, params, lang) ->
  Promise.all([
    store.dispatch(fetchStrings lang).payload.promise
    store.dispatch(articleActions.fetch params).payload.promise
  ]).catch (err) ->
    console.error err.stack
