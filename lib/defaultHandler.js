const createHandler = require('./createRouterHandler.js');
const renderTemplate = require('./renderTemplate.js');

const defaultHandler = createHandler((req, res, config) => {
  const { props } = config;
  if (props) {
    return renderTemplate(config).then(res.send.bind(res));
  }
  return null;
});

module.exports = defaultHandler;
