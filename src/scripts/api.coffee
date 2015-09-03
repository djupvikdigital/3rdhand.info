Promise = require 'bluebird'
request = require 'superagent-bluebird-promise'
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
			.promise()
			.then (res) ->
				if res.ok
					YAML.safeLoad(res.text)
				else
					Promise.reject res.err