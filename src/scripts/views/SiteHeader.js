const React = require('react');
const { connect } = require('react-redux');
const Router = require('react-router');
const { createFactory, elements } = require('react-elementary').default;

const logo = require('logo');

const actions = require('../actions/userActions.js');
const { langPickerSelector, linkSelector } = require(
  '../selectors/appSelectors.js'
);

const LangPicker = createFactory(
  connect(langPickerSelector)(require('./LangPicker.js'))
);

const Link = createFactory(connect(linkSelector)(Router.Link));

const { div, header, li, nav, ul } = elements;

const SiteHeader = React.createClass({
  displayName: 'SiteHeader',
  handleLogout: function handleLogout(e) {
    e.preventDefault();
    const params = Object.assign({}, this.props.params);
    delete params.view;
    const data = {
      from: JSON.stringify(params),
      userId: this.props.login.usser._id,
    };
    return this.props.dispatch(actions.logout(data));
  },
  render: function render() {
    const {
      changePassword, home, logout, newArticle,
    } = this.props.localeStrings;
    const args = [
      { className: 'u-left', role: 'banner' },
      Link({
        className: 'site-logo', title: home, innerHtml: logo, page: 'home',
      }),
    ];
    if (this.props.login.isLoggedIn) {
      args[args.length] = nav(
        { className: 'site-menu menu' },
        ul(
          { className: 'list-bare' },
          li(Link({ page: 'newArticle' }, newArticle)),
          li(Link({ page: 'changePassword' }, changePassword)),
          li(Link({ page: 'logout', onClick: this.handleLogout }, logout))
        )
      );
    }
    return div(header(...args), LangPicker({ className: 'menu u-right' }));
  },
});

module.exports = SiteHeader;
