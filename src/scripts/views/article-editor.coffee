React = require 'react'
ReactRedux = require 'react-redux'
Immutable = require 'immutable'

API = require 'api'
Elements = require '../elements.coffee'
createFactory = require '../create-factory.coffee'
selectors = require '../selectors/app-selectors.coffee'

Helmet = createFactory require 'react-helmet'

Form = createFactory require './form.coffee'
FormMessage = createFactory ReactRedux.connect(selectors.formMessageSelector)(
  require './form-message.coffee'
)
FormGroup = createFactory require './form-group.coffee'
RadioGroup = createFactory require './radio-group.coffee'
RadioOption = createFactory require './radio-option.coffee'
TextInput = createFactory require './text-input.coffee'

utils = require '../utils.coffee'

{ h1, form, label, input, textarea, div } = Elements

keyResolver = (k) ->
  v = @state.data.getIn k
  if Immutable.Map.isMap(v)
    len = k.length
    keys = k.slice 0
    lang = @state.data.get 'lang'
    keys.splice len, 0, lang, 'text'
    keys
  else
    k

module.exports = React.createClass
  displayName: 'ArticleEditor'
  propTypes:
    lang: React.PropTypes.string.isRequired
  handleSubmit: (data) ->
    @props.save Immutable.fromJS(data).filterNot(utils.keyIn('lang')).toJS()
  render: ->
    data = @props.article
    isNew = @props.params.view == 'new'
    props = {
      keyResolver: keyResolver
      onSubmit: @handleSubmit
    }
    if @props.params.view != 'edit'
      data = utils.stripDbFields data
    if isNew
      props.placeholders = data
      data = API.getArticleDefaults()
    if !data.slug && @props.params.slug
      data.slug = @props.params.slug
    data.lang = @props.lang
    props.initialData = data
    l = @props.localeStrings
    title = @props.title
    Helmet { title }
    Form(
      props
      h1 title
      FormMessage type: 'error', name: 'error'
      RadioGroup(
        name: 'lang'
        RadioOption(label: l.norwegian, value: 'nb')
        RadioOption(label: l.english, value: 'en')
      )
      TextInput label: l.slug, name: 'slug'
      TextInput label: l.title, name: 'title'
      TextInput label: l.short_title, name: 'short_title'
      TextInput label: l.headline, name: 'headline'
      TextInput label: l.teaser, name: 'teaser', multiline: true
      TextInput label: l.summary, name: 'summary', multiline: true
      TextInput label: l.intro, name: 'intro', multiline: true
      TextInput label: l.body, name: 'body', multiline: true
      FormGroup(
        input(className: 'btn', type: 'submit', value: l.save)
      )
    )
