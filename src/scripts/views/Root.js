const ReactRedux = require('react-redux');
const { createFactory, elements } = require('react-elementary');

const { titleSelector } = require('../selectors/appSelectors.js');
const routes = require('./routes.js');

const Helmet = createFactory(
  ReactRedux.connect(titleSelector)(require('react-helmet'))
);

const Provider = createFactory(ReactRedux.Provider);

const { div } = elements;

function Root(props) {
  const { store } = props;
  return Provider(
    { store },
    div(
      Helmet({ title: '' }),
      props.children
    )
  );
}

module.exports = Root;
