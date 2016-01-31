Promise = require 'bluebird'
bcrypt = Promise.promisifyAll require 'bcrypt'
t = require 'transducers.js'

{ array } = require './src/scripts/utils.coffee'

serverSecret = 'topsecretstring'

stringify = (input) ->
  JSON.stringify array input, serverSecret

hash = (input) ->
  bcrypt.genSaltAsync(10).then (salt) ->
    bcrypt.hashAsync input, salt

module.exports =
  compare: (input, hash) ->
    if !input || !hash
      throw new Error('missing required arguments')
    bcrypt.compareAsync input, hash
  hash: hash
  serverSecret: serverSecret
  sign: t.compose hash, stringify
  verify: (input, hash) ->
    if !input || !hash
      throw new Error('missing required arguments')
    bcrypt.compareAsync stringify(input), hash
