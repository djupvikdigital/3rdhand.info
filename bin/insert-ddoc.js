#! /usr/bin/env node

var PouchDB = require('pouchdb');
PouchDB.plugin(require('pouchdb-upsert'));

var ddoc = require('../lib/ddoc.js');

var db = new PouchDB('./db/thirdhandinfo');

db.upsert(ddoc._id, function () { return ddoc; }).then(function (res) {
  if (res.updated) {
    console.log('Design document inserted:', res);
  }
}).catch(function (err) {
  console.error('Error inserting design document:', err);
});
