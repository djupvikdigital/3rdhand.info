module.exports = {
	_id: '_design/app',
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