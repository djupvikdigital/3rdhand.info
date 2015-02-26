var couchapp = require('couchapp');

module.exports = {
	_id: '_design/app',
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