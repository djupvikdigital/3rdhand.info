const React = require('react');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary');

const Helmet = createFactory(require('react-helmet'));

const actions = require('../actions/userActions.js');
const { formMessageSelector } = require('../selectors/appSelectors.js');
const URL = require('urlHelpers');

const Form = createFactory(require('./Form.js'));
const FormGroup = createFactory(require('./FormGroup.js'));
const FormMessage = createFactory(
  connect(formMessageSelector)(require('./FormMessage.js'))
);
const Output = createFactory(require('./Output.js'));
const PasswordInput = createFactory(require('./PasswordInput.js'));
const TextInput = createFactory(require('./TextInput.js'));
const SubmitButton = createFactory(require('./SubmitButton.js'));

const { h1, input } = elements;

const LoginDialog = React.createClass({
  displayName: 'LoginDialog',
  getInitialData: function getInitialData() {
    let userId = '';
    const error = '';
    let from = '';
    let name = '';
    if (this.props.login) {
      const { user, params } = this.props.login;
      if (user) {
        userId = user._id;
        name = user.name || userId;
      }
      if (params) {
        from = JSON.stringify(params);
      }
    }
    return { error, from, name, userId };
  },
  handleSubmit: function handleSubmit(data) {
    let promise;
    if (data.resetPassword) {
      promise = this.props.dispatch(actions.requestPasswordReset(data));
    }
    else {
      promise = this.props.dispatch(actions.login(data));
    }
    return promise.then(({ action, value }) => {
      const method = action.error ? 'reject' : 'resolve';
      return Promise[method](value);
    });
  },
  handleLogout: function handleLogout(data) {
    return this.props.dispatch(actions.logout(data));
  },
  render: function render() {
    const l = this.props.localeStrings;
    const {
      email,
      loggedInAs,
      login,
      logout,
      password,
    } = l;
    const { isLoggedIn, user } = this.props.login;
    const title = isLoggedIn ? logout : login;
    Helmet({ title });
    let args;
    if (isLoggedIn) {
      args = [
        {
          action: `${URL.getUserPath(user._id)}/logout`,
          method: 'GET',
          initialData: this.getInitialData(),
        },
        h1(title),
        input({ type: 'hidden', name: 'from' }),
        input({ type: 'hidden', name: 'userId' }),
        Output({ label: loggedInAs, name: 'name' }),
        FormGroup(
          input({ className: 'btn', type: 'submit', value: logout })
        ),
      ];
    }
    else {
      args = [
        {
          action: '/users',
          method: 'POST',
          initialData: this.getInitialData(),
          onSubmit: this.handleSubmit,
        },
        h1(title),
        FormMessage({ type: 'error', name: 'error' }),
        input({ type: 'hidden', name: 'from' }),
        TextInput({ label: email, name: 'email' }),
        PasswordInput({ label: password, name: 'password' }),
        FormGroup(SubmitButton(login)),
      ];
    }
    return Form(...args);
  },
});

module.exports = LoginDialog;
