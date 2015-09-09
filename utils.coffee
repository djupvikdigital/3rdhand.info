fs = require 'fs'
path = require 'path'

module.exports =
	read: (p) ->
		fs.readFileSync path.join(__dirname, p), 'utf-8'
