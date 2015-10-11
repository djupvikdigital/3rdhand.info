var couchapp = require('couchapp');

module.exports = {
	_id: '_design/app',
	validate_doc_update: function (newDoc, oldDoc, userCtx) {
		if (userCtx.roles.indexOf('write') === -1) {
			throw({ unauthorized: 'not authorized' });
		}
	},
	views: {
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