md = require('markdown-it')(xhtmlOut: true)

module.exports =
	markdown: md.render.bind(md)
	markdownInline: md.renderInline.bind(md)
