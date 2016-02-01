fs = require 'fs'
path = require 'path'

module.exports =
  read: (p, cb) ->
    if typeof cb == 'function'
      fs.readFile path.join(__dirname, '..', p), 'utf-8', cb
    else
      fs.readFileSync path.join(__dirname, '..', p), 'utf-8'
