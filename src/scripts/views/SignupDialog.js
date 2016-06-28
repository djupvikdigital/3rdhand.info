const React = require('react');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary').default;

const Helmet = createFactory(require('react-helmet'));

const actions = require('../actions/userActions.js');
const { formMessageSelector } = require('../selectors/appSelectors.js');

const Form = createFactory(require('./Form.js'));
const FormGroup = createFactory(require('./FormGroup.js'));
const FormMessage = createFactory(
  connect(formMessageSelector)(require('./FormMessage.js'))
);
const PasswordInput = createFactory(require('./PasswordInput.js'));
const TextInput = createFactory(require('./TextInput.js'));

const { h1, input } = elements;

const SignupDialog = React.createClass({
  displayName: 'SignupDialog',
  handleSignup: function handleSignup(data) {
    return this.props.dispatch(actions.signup(data));
  },
  render: function render() {
    const {
      email, password, repeatPassword, signup, title,
    } = this.props.localeStrings;
    Helmet({ title });
    return Form(
      { onSubmit: this.handleSignup },
      h1(title),
      FormMessage({ type: 'error', name: 'error' }),
      TextInput({ label: email, name: 'email' }),
      PasswordInput({ label: password, name: 'password' }),
      PasswordInput({ label: repeatPassword, name: 'repeatPassword' }),
      FormGroup(input({ className: 'btn', type: 'submit', value: signup }))
    );
  },
});

module.exports = SignupDialog;
