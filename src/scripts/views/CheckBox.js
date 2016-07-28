const { createClass } = require('react');
const { elements } = require('react-elementary').default;

const { input, label } = elements;

function stringifyComplex(value) {
  return typeof value == 'object' ? JSON.stringify(value) : value;
}

const CheckBox = createClass({
  displayName: 'CheckBox',
  propsToState: function propsToState({ value }) {
    return { value };
  },
  getInitialState: function getInitialState() {
    return this.propsToState(this.props);
  },
  componentWillReceiveProps: function componentWillReceiveProps({ value }) {
    if (value) {
      this.setState({ value });
    }
  },
  handleChange: function handleChange({ target }) {
    const { name, onChange } = this.props;
    const value = target.checked ? this.state.value : '';
    if (typeof onChange == 'function') {
      onChange({ target: { name, value } });
    }
  },
  render: function render() {
    const props = this.props;
    const { name } = props;
    const value = stringifyComplex(this.state.value);
    return label(
      { className: 'form-group' },
      `${props.label}: `,
      input({
        type: 'checkbox',
        checked: !!props.value,
        onChange: this.handleChange,
        name,
        value,
      })
    );
  },
});

module.exports = CheckBox;
