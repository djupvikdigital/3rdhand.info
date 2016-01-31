module.exports =
  _id: '_design/app'
  validate_doc_update: (newDoc, oldDoc, userCtx) ->
    if userCtx.roles.indexOf('write') == -1
      throw unauthorized: 'not authorized'
  views:
    by_email:
      map: ((doc) ->
        if doc.email
          emit [ doc.type, doc.email ], null
      ).toString()
    by_slug_and_date:
      map: ((doc) ->
        emit [ doc.type, doc.slug, doc.created ], null
      ).toString()
    by_updated:
      map: ((doc) ->
        if doc.updated
          doc.updated.forEach (update, i, arr) ->
            # value is count of times a document is reemitted
            emit [ doc.type, update ], arr.length - 1 - i
      ).toString()
      reduce: '_sum'
