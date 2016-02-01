#! /usr/bin/env node

var PouchDB = require('pouchdb');
var db = new PouchDB('./db/thirdhandinfo');
db.destroy();
