#! /usr/bin/env node

var path = require('path');
var PouchDB = require('pouchdb');
var db = new PouchDB(path.resolve(__dirname, '../db/thirdhandinfo'));
var log = console.log.bind(console);

function getDocFromRow(row) {
  return row.doc;
}

function getDocs(body) {
  return body.rows.map(getDocFromRow);
}

function stringify(data) {
  return JSON.stringify(data, null, 2);
}

db.allDocs({ include_docs: true })
  .then(getDocs)
  .then(stringify)
  .then(log)
  .catch(log);
