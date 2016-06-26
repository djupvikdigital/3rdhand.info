const Immutable = require('immutable');
const React = require('react');
const { connect } = require('react-redux');
const { createFactory } = require('react-elementary').default;

const actions = require('../actions/articleActions.js');
const { loginSelector } = require('../selectors/appSelectors.js');
const { editorSelector, itemSelector } = require(
  '../selectors/articleSelectors.js'
);

const authenticate = require('./authenticate.js');

const ArticleList = createFactory(require('./ArticleList.js'));
const ArticleFull = createFactory(
  connect(itemSelector)(require('./ArticleFull.js'))
);
const ArticleEditor = createFactory(
  connect(loginSelector)(
    authenticate(connect(editorSelector)(require('./ArticleEditor.js')))
  )
);

const ArticleContainer = React.createClass({
  displayName: 'ArticleContainer',
  fetch: function (params, force) {
    const prevParams = Immutable.Map(this.props.prevParams);
    if (force || !Immutable.is(prevParams, Immutable.Map(params))) {
      return this.props.dispatch(actions.fetch(params));
    }
    return null;
  },
  save: function (data) {
    return this.props.dispatch(actions.save(data, this.props.login.user._id));
  },
  componentWillMount: function () {
    return this.fetch(this.props.params);
  },
  componentWillReceiveProps: function (nextProps) {
    return this.fetch(nextProps.params, nextProps.refetch);
  },
  render: function () {
    const params = this.props.params || {};
    const { articles, serverUrl } = this.props;
    if (articles.length > 1) {
      return ArticleList({ articles });
    }
    else if (params.view) {
      return ArticleEditor({ save: this.save, params: params });
    }
    return ArticleFull({ serverUrl });
  },
});

module.exports = ArticleContainer;
