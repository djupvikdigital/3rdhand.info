const React = require('react');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary').default;

const { headerSelector } = require('../selectors/appSelectors.js');

const SiteHeader = createFactory(
  connect(headerSelector)(require('./site-header.coffee'))
);

const { div } = elements;

function App(props) {
  const { serverUrl } = props.route;
  return div(
    { className: 'u-overflow-hidden' },
    SiteHeader(),
    div(
      { className: 'wrapper' },
      React.cloneElement(props.children, { serverUrl })
    )
  );
}

module.exports = App;
