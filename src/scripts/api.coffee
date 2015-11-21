Promise = require 'bluebird'
request = require 'superagent'
require('superagent-as-promised')(request)
YAML = require 'js-yaml'

store = require './store.coffee'

protocol = 'http://'
host = 'localhost:8081'
server = protocol + host + '/'

module.exports =
	fetchArticleSchema: ->
		req = request
			.get(server + 'schema/article-schema.yaml')
		if typeof req.buffer == 'function'
			req.buffer()
		req
			.then (res) ->
				if res.ok
					YAML.safeLoad(res.text)
				else
					Promise.reject res.err