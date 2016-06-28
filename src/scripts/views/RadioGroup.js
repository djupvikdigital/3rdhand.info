const Immutable = require('immutable');
const { Children, cloneElement } = require('react');
const { elements } = require('react-elementary');

const RadioOption = require('./RadioOption.js');

const { div, fieldset, legend } = elements;

function renderChildren(_props) {
  const { name, onChange, value } = _props;
  const props = Immutable.Map({ name, onChange });
  return Children.map(_props.children, child => {
    if (child.type === RadioOption) {
      return cloneElement(
        child,
        props.set('checked', child.props.value === value).toJS(),
        child.props.children
      );
    }
    return child;
  });
}

function RadioGroup(props) {
  const { label } = props;
  if (label) {
    return fieldset(legend(label), renderChildren(props));
  }
  return div(renderChildren(props));
}

module.exports = RadioGroup;
