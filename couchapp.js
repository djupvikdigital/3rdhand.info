var couchapp = require('couchapp');

module.exports = {
	_id: '_design/app',
	validate_doc_update: function (newDoc, oldDoc, userCtx) {
		if (userCtx.roles.indexOf('write') === -1) {
			throw({ unauthorized: 'not authorized' });
		}
	},
	views: {
		articlesByDateAndSlug: {
			map: function (doc) {
				if (doc.created && doc.slug) {
					var date = new Date(doc.created);
					emit([date.toDateString(), doc.slug], doc);
				}
			}
		},
		articlesByMostRecentlyUpdated: {
			map: function (doc) {
				if (doc.updated) {
					emit(doc.updated, doc);
				}
			}
		}
	},
	lists: {},
	shows: {}
};