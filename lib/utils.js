const fs = require('fs');
const path = require('path');

const docuri = require('docuri');
const moment = require('moment');
const R = require('ramda');

const route = docuri.route('article/:created');

function getKey(slug, date) {
  let dateKey = null;
  if (date) {
    dateKey = typeof date.toISOString == 'function' ? date.toISOString() : date;
  }
  if (slug) {
    return ['article', slug, dateKey].filter(Boolean);
  }
  else if (dateKey) {
    return route({ created: dateKey });
  }
  throw new Error('could not construct key');
}

function buildDateQuery(params) {
  if (!params.year) {
    return null;
  }
  const dateKeys = ['year', 'month', 'day'];
  const dateParams = R.map(Number, R.pick(dateKeys, params));
  if (dateParams.month) {
    dateParams.month -= 1;
  }
  const date = moment.utc(dateParams);
  const durationKey = dateKeys[
    dateKeys.length - R.difference(dateKeys, Object.keys(dateParams)).length - 1
  ];
  if (durationKey) {
    return {
      endkey: getKey(params.slug, date),
      startkey: getKey(params.slug, date.add(1, durationKey)),
    };
  }
  return null;
}

// Public API

function buildQuery(params) {
  let query = {
    endkey: ['article'],
    startkey: ['article\uffff'],
  };
  let view = 'by_updated';
  if (params.slug) {
    view = 'by_slug_and_date';
    // endkey is earlier thant startkey because we use descending order
    query = {
      endkey: getKey(params.slug),
      startkey: getKey(params.slug, {}),
    };
  }
  query = buildDateQuery(params) || query;
  if (params.slug) {
    query.slug = params.slug;
  }
  query.descending = true;
  if (!params.userId) {
    view = `published_${view}`;
  }
  return { query, view };
}

const getDocumentId = R.pipe(
  R.evolve({ created: R.prop('utc') }),
  docuri.route(':type/:created/:slug')
);

function read(p, cb) {
  if (typeof cb == 'function') {
    return fs.readFile(path.join(__dirname, '..', p), 'utf-8', cb);
  }
  return fs.readFileSync(path.join(__dirname, '..', p), 'utf-8');
}

module.exports = { buildQuery, getDocumentId, read };
