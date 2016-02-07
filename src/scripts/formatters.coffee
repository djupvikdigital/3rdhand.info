md = require('markdown-it')(xhtmlOut: true).use require 'markdown-it-deflist'

module.exports =
  markdown: md.render.bind(md)
  markdownInline: md.renderInline.bind(md)
