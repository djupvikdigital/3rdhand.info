#! /usr/bin/env node

var path = require('path');
var PouchDB = require('pouchdb');
var db = new PouchDB(path.resolve(__dirname, '../db/thirdhandinfo'));
var log = console.log.bind(console);

var encoding = 'utf-8';
var data;

function processData() {
  db.bulkDocs(JSON.parse(data)).then(log).catch(log);
}

if (process.stdin.isTTY) {
  data = new Buffer(process.argv[2] || '', encoding);
  processData();
}
else {
  data = '';
  process.stdin.setEncoding(encoding);
  process.stdin.on('readable', function () {
    var chunk;
    while (chunk = process.stdin.read()) {
      data += chunk;
    }
  });
  process.stdin.on('end', function () {
    data = data.replace(/\n$/, '');
    processData();
  })
}
