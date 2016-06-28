const moment = require('moment');
const React = require('react');
const { createFactory } = require('react-elementary');

const actions = require('../actions/userActions.js');

const LoginDialog = createFactory(require('./LoginDialog.js'));

function checkTimestamp({ dispatch, login }) {
  if (login.isLoggedIn) {
    const timestamp = login.authenticationTime;
    if (moment.duration(Date.now() - timestamp).asMinutes() > 30) {
      dispatch(actions.sessionTimeout());
    }
  }
}

function authenticate(Component) {
  return React.createClass({
    componentWillMount: function componentWillMount() {
      checkTimestamp(this.props);
    },
    componentDidUpdate: function componentDidUpdate() {
      checkTimestamp(this.props);
    },
    render: function render() {
      const props = this.props;
      if (props.login.isLoggedIn) {
        return React.createElement(Component, props);
      }
      return LoginDialog(props);
    },
  });
}

module.exports = authenticate;
