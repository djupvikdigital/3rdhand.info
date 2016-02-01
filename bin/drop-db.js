#! /usr/bin/env node

var PouchDb = require('pouchdb');
var db = new PouchDB('./db/thirdhandinfo');
db.destroy();
