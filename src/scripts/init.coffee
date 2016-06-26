articleActions = require './actions/articleActions.js'
{ fetchStrings } = require './actions/locale-actions.coffee'

module.exports = (store, params, lang) ->
  Promise.all([
    store.dispatch fetchStrings lang
    store.dispatch articleActions.fetch params
  ]).catch (err) ->
    console.error err.stack || err
