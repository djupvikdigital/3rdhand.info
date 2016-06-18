#! /usr/bin/env node

var path = require('path');
var PouchDB = require('pouchdb');
var db = new PouchDB(path.resolve(__dirname, '../db/thirdhandinfo'));
var log = console.log.bind(console);

function getRows(body) {
  return body.rows;
}

db.allDocs().then(getRows).then(JSON.stringify).then(log).catch(log);
