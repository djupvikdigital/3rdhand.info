const React = require('react');
const { elements } = require('react-elementary').default;

const { input, label, textarea } = elements;

const TextInput = React.createClass({
  displayName: 'TextInput',
  getDefaultProps: function () {
    return { multiline: false, placeholder: '' };
  },
  render: function () {
    const { multiline, name, onChange, placeholder, value } = this.props;
    const el = multiline ? textarea : input;
    return label(
      { className: 'form-group'},
      `${this.props.label}: `,
      el({ name, value, placeholder, onChange })
    );
  },
});

module.exports = TextInput;
