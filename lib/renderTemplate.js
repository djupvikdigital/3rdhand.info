const r = require('react').createElement;
const ReactDOM = require('react-dom/server');
const Helmet = require('react-helmet');
const ReactRouter = require('react-router');
const { createFactory } = require('react-elementary').default;

const init = require('../src/scripts/init.js');
const IndexTemplate = require('../views/index.js');
const Root = createFactory(require('../src/scripts/views/Root.js'));

const RouterContext = createFactory(ReactRouter.RouterContext);

function renderTemplate(config) {
  const { lang, params, storeModule } = config;
  const props = config.props || {};
  const Template = config.Template || IndexTemplate;
  const { store } = storeModule;
  return init(store, params, lang).then(() => {
    const doctype = '<!DOCTYPE html>';
    const app = ReactDOM.renderToString(Root({ store }, RouterContext(props)));
    const h = Helmet.rewind();
    const title = h.title.toComponent()[0];
    const meta = h.meta.toComponent();
    const state = store.getState();
    const siteTitle = state.localeState.toJS().localeStrings[lang].title || '';
    const html = ReactDOM.renderToStaticMarkup(
      r(Template, { app, lang, meta, siteTitle, state, title })
    );
    return doctype + html;
  });
}

module.exports = renderTemplate;
