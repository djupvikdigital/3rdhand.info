const { elements } = require('react-elementary').default;

const { input } = elements;

function SubmitButton(props) {
  const childProps = {
    className: 'btn',
    type: 'submit',
    name: props.name,
    value: props.children,
  };
  if (typeof props.onChange == 'function') {
    childProps.onClick = props.onChange;
  }
  return input(childProps);
}

module.exports = SubmitButton;
