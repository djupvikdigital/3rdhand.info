nano = require('nano')

url = 'http://localhost:5984'

module.exports = (cookie) ->
	config =
		url: url
	config.cookie = cookie if cookie
	nano(config).use('thirdhandinfo')
