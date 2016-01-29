Promise = require 'bluebird'

sendMail = (settings) ->
	Promise.resolve
		response: settings

defaults =
	from: 'mail@3rdhand.info'

module.exports = (options) ->
	settings = Object.assign {}, defaults, options
	sendMail(settings).then (info) ->
		console.log 'Message sent:', info.response
		return info
