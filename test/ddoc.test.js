const expect = require('expect');

const memdown = require('memdown');
const PouchDB = require('pouchdb');
const R = require('ramda');

const { createDatetimeStruct } = require('../src/scripts/utils.js');
const ddoc = require('../lib/ddoc.js');
const { buildQuery, getDocumentId } = require('../lib/utils.js');

function createDB(docs) {
  const db = new PouchDB('test', { db: memdown });
  return db.bulkDocs([ddoc].concat(docs)).then(() => db);
}

function createDoc(date) {
  return { created: createDatetimeStruct(new Date(date)), slug: 'test' };
}

describe('ddoc', () => {
  describe('by_slug_and_date', () => {
    it('selects only documents in the specific date range', (done) => {
      const docs = [
        '2016-06-18T19:00:00Z',
        '2016-07-18T19:00:00Z',
      ].map(R.pipe(createDoc, doc => R.assoc('_id', getDocumentId(doc), doc)));
      createDB(docs)
        .then(
          db => db.query(
            'app/by_slug_and_date',
            buildQuery({ year: 2016, month: 6, day: 18, slug: 'test' })
          )
        )
        .then(res => {
          expect(res.rows.length).toBe(1);
          done();
        })
        .catch(done);
    });
  });
});
