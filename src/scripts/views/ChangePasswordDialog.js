const React = require('react');
const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary').default;

const actions = require('../actions/userActions.js');
const { formMessageSelector } = require('../selectors/appSelectors.js');
const URL = require('urlHelpers');

const Helmet = createFactory(require('react-helmet'));

const Form = createFactory(require('./form.coffee'));
const FormMessage = createFactory(
  connect(formMessageSelector)(require('./form-message.coffee'))
);
const FormGroup = createFactory(require('./form-group.coffee'));
const PasswordInput = createFactory(require('./password-input.coffee'));
const SubmitButton = createFactory(require('./submit-button.coffee'));
const TextInput = createFactory(require('./text-input.coffee'));

const { h1, input } = elements;

const ChangePasswordDialog = React.createClass({
  displayName: 'ChangePasswordDialog',
  handleReset: function (data) {
    const { dispatch, params } = this.props;
    return dispatch(actions.changePassword(params.userId, data))
      .then(action => {
        const method = action.error ? 'reject' : 'resolve';
        return Promise[method](action.payload.response.body);
      })
  },
  render: function () {
    const { location, localeStrings, params } = this.props;
    let data = {};
    if (location && location.query) {
      data = location.query;
    }
    const id = params.userId;
    const timestamp = data.timestamp || '';
    const token = data.token || '';
    const {
      changePassword, newPassword, oldPassword, repeatPassword, title
    } = localeStrings;
    const props = {
      action: URL.getUserPath(id),
      method: 'POST',
      initialData: { id, timestamp, token },
      onSubmit: this.handleReset,
    };
    let inputs;
    if (timestamp && token) {
      inputs = [
        input({ type: 'hidden', name: 'timestamp' }),
        input({ type: 'hidden', name: 'token' }),
      ];
    }
    else {
      inputs = [
        PasswordInput({ label: oldPassword, name: 'password' }),
      ];
    }
    const args = [
      props,
      h1(title),
      FormMessage({ type: 'error', name: 'error' }),
      input({ type: 'hidden', name: 'id' }),
    ].concat(inputs, [
      PasswordInput({ label: newPassword, name: 'newPassword' }),
      PasswordInput({ label: repeatPassword, name: 'repeatPassword' }),
      FormGroup(SubmitButton({ name: 'changePassword'}, changePassword)),
    ]);
    Helmet({ title });
    return Form.apply(null, args);
  },
});

module.exports = ChangePasswordDialog;
