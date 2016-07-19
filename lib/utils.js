const fs = require('fs');
const path = require('path');

const docuri = require('docuri');
const R = require('ramda');

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

module.exports = { getDocumentId, read };
