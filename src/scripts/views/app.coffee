ReactRedux = require 'react-redux'
Router = require 'react-router'

createFactory = require '../create-factory.coffee'
selectors = require '../selectors/app-selectors.coffee'
Elements = require '../elements.coffee'

logo = require 'logo'

Link = createFactory ReactRedux.connect(selectors.linkSelector)(Router.Link)
SiteMenu = createFactory(
	ReactRedux.connect(selectors.menuSelector)(require './site-menu.coffee')
)

{ header, div } = Elements

module.exports = (props) ->
	div(
		header(
			className: 'site-header', role: 'banner'
			Link className: 'site-header__logo', innerHtml: logo
		)
		SiteMenu()
		div(
			className: 'wrapper'
			props.children
		)
	)

module.exports.displayName = 'App'
