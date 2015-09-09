React = require 'react'

utils = require '../utils.coffee'
Elements = require '../src/scripts/elements.coffee'

{ html, head, meta, title, link, body, header, div, script } = Elements

siteHeader = utils.read '/dist/svg/site-header.svg'
logo = utils.read '/dist/svg/logo.svg'

googleFontsUrl = 'http://fonts.googleapis.com/css?family='

module.exports = React.createClass
	render: ->
		html(
			head(
				meta(charSet: "utf-8")
				meta(
					name: "viewport"
					content: "width=device-width, initial-scale=1"
				)
				title(@props.title)
				link(rel: "stylesheet", href: "/normalize.css")
				link(
					rel: "stylesheet"
					href: googleFontsUrl + "Open+Sans:400,400italic,700,700italic,800italic"
				)
				link(
					rel: "stylesheet"
					href: googleFontsUrl + "Rokkitt:400,700"
				)
				link(
					rel: "stylesheet"
					href: "http://localhost:8080/dist/styles/main.css"
				)
			)
			body(
				header(
					{ className: "site-header", role: "banner" }
					div(
						className: "site-header__logo"
						innerHtml: logo
					)
					div(
						className: "site-header__title"
						innerHtml: siteHeader
					)
				)
				div(id: "app", innerHtml: @props.app)
				script(src: "http://localhost:8080/dist/scripts/main.js")
			)
		)
