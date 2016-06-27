const YAML = require('js-yaml');
const { elements } = require('react-elementary').default;

const { read } = require('../lib/utils.js');

const conf = YAML.safeLoad(read('./config.yaml'));

const { assetServer } = conf;
const server = assetServer ? `//${assetServer.hostname}:${assetServer.port}` : '';

const assetPaths = conf.assetPaths || require('../dist/webpack-assets.json');

const { html, head, meta, title, link, body, header, div, script } = elements;

const googleFontsUrl = '//fonts.googleapis.com/css?family=';
const stylesheets = [
  `${googleFontsUrl}Open+Sans:400,400italic,700,700italic,800italic`,
  `${googleFontsUrl}Rokkitt:400,700`,
  server + assetPaths.styles.css,
];

function IndexTemplate(props) {
  const metadata = [
    meta({ charSet: 'utf-8' }),
    meta({ name: 'viewport', content: 'width=device-width, initial-scale=1' }),
    props.title,
    link({
      rel: 'alternate',
      type: 'application/atom+xml',
      title: props.siteTitle,
      href: '/index.atom',
    }),
  ].concat(props.meta, stylesheets.map(
    href => link({ rel: 'stylesheet', href: href })
  ));
  return html(
    { lang: props.lang },
    head(...metadata),
    body(
      div({ id: 'app', innerHtml: props.app }),
      script(
        { id: 'state', type: 'application/json' },
        JSON.stringify(props.state)
      ),
      script({ src: server + assetPaths.scripts.js })
    )
  );
}

module.exports = IndexTemplate;
