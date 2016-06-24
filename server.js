require('coffee-script/register');

const fs = require('fs');
const path = require('path');
const https = require('https');

const express = require('express');
const favicon = require('serve-favicon');
const bodyParser = require('body-parser');

const _ = require('lodash');
const R = require('ramda');
const { createMemoryHistory } = require('react-router');

const PROD = process.env.NODE_ENV === 'production';
const DEV = !PROD;

const API = require('./src/node_modules/api.js');
const articleSelectors = require(
  './src/scripts/selectors/article-selectors.coffee'
);
const createStore = require('./src/scripts/store.coffee');
const init = require('./src/scripts/init.coffee');
const logger = require('./lib/log.js');
const negotiateLang = require('./lib/negotiate-lang.coffee');
const siteRouter = require('./routers/site-router.coffee');
const URL = require('./src/node_modules/url-helpers.coffee');
const userRouter = require('./routers/user-router.coffee');

server = express();
server.use(favicon('./favicon.ico'));
server.use(bodyParser.json());
server.use(bodyParser.urlencoded({ extended: true }));

server.use(express.static(path.resolve(__dirname, 'dist')));
server.set('views', './views');
server.set('view engine', 'jade');

server.get('/index.atom', (req, res) => {
  const lang = negotiateLang(req);
  res.header('Content-Type', 'application/atom+xml; charset=utf8');
  const { store } = createStore(createMemoryHistory());
  init(store, {}, lang).then(() => {
    let { articles } = articleSelectors.containerSelector(store.getState());
    articles = articles.map(
      article => R.merge(article, { href: URL.getPath(article.urlParams) })
    );
    const updated = articles.length ? R.last(articles[0].updated) : '';
    const host = URL.getServerUrl(req);
    const root = `${host}/`;
    const url = host + req.url;
    res.render('feed', { articles, host, root, updated, url });
  });
});

server.get('/locales/:lang', (req, res) => {
  API.fetchLocaleStrings(req.params.lang).then(res.send.bind(res));
});

server.use('/users', userRouter);
server.use('/', siteRouter);

server.use((err, req, res, next) => {
  logger.error(err);
  res.sendStatus(500);
});

server.listen(8081, () => {
  logger.info('Express web server listening on port 8081...');
});
