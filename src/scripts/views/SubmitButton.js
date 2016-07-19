const { elements } = require('react-elementary').default;

const { button } = elements;

function SubmitButton(props) {
  const childProps = {
    className: 'btn',
    type: 'submit',
    name: props.name,
    value: props.value,
  };
  if (typeof props.onChange == 'function') {
    childProps.onClick = props.onChange;
  }
  return button(childProps, props.children);
}

module.exports = SubmitButton;
