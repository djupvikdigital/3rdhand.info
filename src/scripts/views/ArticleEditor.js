const Immutable = require('immutable');
const React = require('react');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary');

const API = require('api');
const { formMessageSelector } = require('../selectors/appSelectors.js');
const utils = require('../utils.js');

const Helmet = createFactory(require('react-helmet'));

const CheckBox = createFactory(require('./CheckBox.js'));
const Form = createFactory(require('./Form.js'));
const FormMessage = createFactory(
  connect(formMessageSelector)(require('./FormMessage.js'))
);
const FormGroup = createFactory(require('./FormGroup.js'));
const RadioGroup = createFactory(require('./RadioGroup.js'));
const RadioOption = createFactory(require('./RadioOption.js'));
const TextInput = createFactory(require('./TextInput.js'));
const SubmitButton = createFactory(require('./SubmitButton.js'));

const { h1 } = elements;

function keyResolver(k) {
  const v = this.state.data.getIn(k);
  if (Immutable.Map.isMap(v)) {
    const lang = this.state.data.get('lang');
    const len = k.length;
    const keys = k.slice(0);
    keys.splice(len, 0, lang, 'text');
    return keys;
  }
  return k;
}

const ArticleEditor = React.createClass({
  displayName: 'ArticleEditor',
  propTypes: {
    lang: React.PropTypes.string.isRequired,
  },
  handleSubmit: function handleSubmit(data) {
    return this.props.save(
      Immutable.fromJS(data).filterNot(utils.keyIn('lang')).toJS()
    );
  },
  render: function render() {
    let data = this.props.article;
    const { lang, params, title } = this.props;
    const isNew = params.view === 'new';
    const props = {
      keyResolver,
      onSubmit: this.handleSubmit,
    };
    if (params.view !== 'edit') {
      data = utils.stripDbFields(data);
    }
    if (isNew) {
      props.placeholders = data;
      data = API.getArticleDefaults();
    }
    if (!data.slug && params.slug) {
      data.slug = params.slug;
    }
    data.lang = lang;
    props.initialData = data;
    const l = this.props.localeStrings;
    const {
      body,
      english,
      headline,
      intro,
      norwegian,
      publish,
      published,
      save,
      short_title,
      slug,
      summary,
      teaser,
    } = l;
    const isPublished = data.hasOwnProperty('published');
    const submits = [SubmitButton(save)];
    if (!isPublished) {
      submits.push(
        ' ',
        SubmitButton({ name: 'published', value: '{}' }, publish)
      );
    }
    Helmet({ title });
    const args = [
      props,
      h1(title),
      FormMessage({ type: 'error', name: 'error' }),
      RadioGroup(
        { name: 'lang' },
        RadioOption({ label: norwegian, value: 'nb' }),
        RadioOption({ label: english, value: 'en' })
      ),
      TextInput({ label: slug, name: 'slug' }),
      TextInput({ label: l.title, name: 'title' }),
      TextInput({ label: short_title, name: 'short_title' }),
      TextInput({ label: headline, name: 'headline' }),
      TextInput({ label: teaser, name: 'teaser', multiline: true }),
      TextInput({ label: summary, name: 'summary', multiline: true }),
      TextInput({ label: intro, name: 'intro', multiline: true }),
      TextInput({ label: body, name: 'body', multiline: true }),
      isPublished ? CheckBox({ label: published, name: 'published' }) : null,
      FormGroup(...submits),
    ].filter(Boolean);
    return Form(...args);
  },
});

module.exports = ArticleEditor;
