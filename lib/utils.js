const fs = require('fs');
const path = require('path');

function read(p, cb) {
  if (typeof cb == 'functon') {
    return fs.readFile(path.join(__dirname, '..', p), 'utf-8', cb);
  }
  return fs.readFileSync(path.join(__dirname, '..', p), 'utf-8');
}

module.exports = { read };
