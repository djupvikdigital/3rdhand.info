const { replace } = require('react-router-redux');

const createHandler = require('createRouterHandler.js');
const renderTemplate = require('render-template.coffee');

const defaultHandler = createHandler((req, res, config) => {
  const { props } = config;
  if (props) {
    return renderTemplate(config).then(res.send.bind(res));
  }
});

module.exports = defaultHandler;
