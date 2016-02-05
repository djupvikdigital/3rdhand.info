#! /usr/bin/env node

var path = require('path');
var PouchDB = require('pouchdb');
var db = new PouchDB(path.resolve(__dirname, '../db/thirdhandinfo'));
var log = console.log.bind(console);
db.destroy().then(log).catch(log);
