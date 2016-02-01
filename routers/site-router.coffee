router = require('express').Router()
ReduxRouter = require 'react-router-redux'

logger = require '../lib/log.coffee'
API = require '../src/node_modules/api.coffee'
renderTemplate = require '../lib/render-template.coffee'
negotiateLang = require '../lib/negotiate-lang.coffee'
createStore = require '../src/scripts/store.coffee'
userActions = require '../src/scripts/actions/user-actions.coffee'
createHandler = require '../lib/create-router-handler.coffee'
URL = require '../lib/url.coffee'

setUser = (session, userId, dispatch) ->
  if !userId then return false
  id = 'user/' + userId
  if session && session.user._id == id
    dispatch userActions.setUser session.user._id
    return true
  return false

router.get '*', createHandler (req, res, props) ->
  if !props
    throw new Error('no route match')
  params = URL.getParams props.params
  res.format
    html: ->
      storeModule = createStore()
      { store, history } = storeModule
      if req.user
        store.dispatch userActions.setUser req.user._id
      else
        setUser req.session, params.userId, store.dispatch
      url = req.originalUrl
      store.dispatch(
        ReduxRouter.routeActions.replace pathname: url, state: params
      )
      renderTemplate storeModule, params, negotiateLang req
        .then res.send.bind res
    default: ->
      API.fetchArticles params
        .then res.send.bind res
        .catch (err) ->
          logger.error err
          res.sendStatus 500

module.exports = router
