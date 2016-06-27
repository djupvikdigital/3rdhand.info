const md = require('markdown-it')({ xhtmlOut: true })
  .use(require('markdown-it-deflist'));

const formatters = {
  markdown: md.render.bind(md),
  markdownInline: md.renderInline.bind(md),
};

module.exports = formatters;
