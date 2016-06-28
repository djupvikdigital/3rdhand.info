/* global emit */

module.exports = {
  _id: '_design/app',
  validate_doc_update(newDoc, oldDoc, userCtx) {
    if (userCtx.roles.indexOf('write') === -1) {
      throw new Error({ unauthorized: 'not authorized' });
    }
  },
  views: {
    by_email: {
      map: (function map(doc) {
        if (doc.email) {
          emit([doc.type, doc.email], null);
        }
      }).toString(),
    },
    by_slug_and_date: {
      map: (function map(doc) {
        if (doc.created) {
          emit([doc.type, doc.slug, doc.created.utc], null);
        }
      }).toString(),
    },
    by_updated: {
      map: (function map(doc) {
        if (doc.updated) {
          doc.updated.forEach((update, i, arr) => {
            // value is count of times a document is reemitted
            emit([doc.type, update.utc], arr.length - 1 - i);
          });
        }
      }).toString(),
      reduce: '_sum',
    },
  },
};
