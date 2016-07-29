const omit = require('ramda/src/omit');
const r = require('react').createElement;
const Router = require('react-router');

function Link(props) {
  const customProps = [
    'currentParams', 'dispatch', 'langParam', 'page', 'params', 'slug',
  ];
  return r(Router.Link, omit(customProps, props), props.children);
}

module.exports = Link;
