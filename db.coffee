PouchDB = require 'pouchdb'
PouchDB.plugin require 'pouchdb-upsert'
Promise = require 'bluebird'
cuid = require 'cuid'
moment = require 'moment'

t = require 'transducers.js'

logger = require './log.coffee'
Crypto = require './crypto.coffee'
utils = require './src/scripts/utils.coffee'
URL = require './src/scripts/url.coffee'
ddoc = require './ddoc.coffee'

diff = ->
  ddoc

db = new PouchDB('./db/thirdhandinfo')

getQueryProps = (query) ->
  props = [ 'key', 'startkey', 'endkey', 'descending' ]
  utils.getProps query, props

getDocFromRow = (row) ->
  row.doc

defaultTransform = (body) ->
  return t.map body.rows, getDocFromRow

viewHandlers =
  by_email: (query) ->
    query.include_docs = true
    db.query 'app/by_email', query
      .then (body) ->
        if body.rows.length
          getDocFromRow body.rows[0]
        else
          Promise.reject new Error('no user match')
  by_updated: (query) ->
    query.include_docs = true
    query.reduce = false
    db.query 'app/by_updated', query
      .then (body) ->
        return t.seq body.rows, t.compose(
          t.filter (row) ->
            !row.value
          t.map getDocFromRow
        )

defaultViewHandler = (view, query) ->
  query.include_docs = true
  db.query 'app/' + view, query
    .then defaultTransform

allHandler = (query) ->
  query.include_docs = true
  db.allDocs query
    .then defaultTransform

get = (arg1) ->
  view = if arguments.length == 2 then arg1 else ''
  query = getQueryProps arguments[arguments.length - 1]
  if !view
    allHandler query
  else if typeof viewHandlers[view] == 'function'
    viewHandlers[view](query)
  else
    defaultViewHandler view, query

put = (userId, doc) ->
  if !userId
    return Promise.reject new Error('login required')
  db.get(userId).then (user) ->
    if user.roles.indexOf('write') != -1
      db.put doc
    else
      Promise.reject new Error('permission denied')

onAuthenticate = (user) -> 
  (success) ->
    if !success
      return Promise.reject new Error('authentication failed')
    return user

authenticateByPassword = (userPromise, data) ->
  password = data.password
  userPromise.then (user) ->
    Crypto.compare(password, user.password_hash).then onAuthenticate user

authenticateByToken = (userPromise, data) ->
  { timestamp } = data
  if moment.duration(Date.now() - timestamp).asMinutes() > 60
    throw new Error('token expired')
  userPromise.then (user) ->
    path = URL.getUserPath(user._id) + '/change-password'
    arr = [ user.password_hash, path, timestamp ]
    Crypto.verify(arr, data.token).then onAuthenticate user

authenticate = (data) ->
  if data.email
    userPromise = viewHandlers.by_email key: [ 'user', data.email ]
  else if data.userId
    userPromise = allHandler(key: 'user/' + data.userId).then utils.prop 0
  else
    return Promise.reject new Error('required fields missing')
  if data.password
    fn = authenticateByPassword
  else if data.token && data.timestamp
    fn = authenticateByToken
  else
    return Promise.reject new Error('authentication failed')
  fn userPromise, data
    .catch (err) ->
      if err.status == 404
        logger.warn 'Invalid login attempt'
        err = new Error('authentication failed')
        err.status = 401
      throw err

getUserId = ->
  'user/' + cuid()

isSignupAllowed = ->
  # only one user allowed - TODO: make configurable
  get startkey: 'user', endkey: 'user\uffff'
    .then (users) ->
      !users.length

addUser = (data) ->
  if !data || data.password != data.repeatPassword
    throw new Error('repeat password mismatch')
  isSignupAllowed()
    .then (isAllowed) ->
      if !isAllowed
        error = new Error('permission denied')
        error.status = 403
        throw error
      return true
    .then ->
      Crypto.hash data.password
    .then (hash) ->
      doc =
        _id: getUserId()
        type: 'user'
        email: data.email
        password_hash: hash
        roles: [ 'write' ]
      db.put doc

changePassword = (data) ->
  if !data.newPassword || !data.userId
    return Promise.reject new Error('required fields missing')
  if data.newPassword != data.repeatPassword
    return Promise.reject new Error('repeat password mismatch')
  authenticate data
    .then (user) ->
      Crypto.hash(data.newPassword).then (hash) ->
        user.password_hash = hash
        db.put user

if !true
  db.upsert ddoc._id, diff
    .then (res) ->
      if res.updated
        console.log 'Design document inserted:'
        console.log res
    .catch (err) ->
      console.log 'Error inserting design document:'
      console.log err

if !true
  db.destroy()

module.exports = {
  addUser
  authenticate
  changePassword
  db
  get
  isSignupAllowed
  put
}
