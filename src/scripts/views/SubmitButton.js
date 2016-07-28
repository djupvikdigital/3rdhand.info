const { elements } = require('react-elementary').default;

const { button } = elements;

function createHandler({ name, onChange, value }) {
  return () => onChange({ target: { name, value } });
}

function SubmitButton(props) {
  const { name, onChange, value } = props;
  const childProps = {
    className: 'btn',
    type: 'submit',
    name,
    value: typeof value == 'object' ? JSON.stringify(value) : value,
  };
  if (typeof onChange == 'function') {
    childProps.onClick = createHandler(props);
  }
  return button(childProps, props.children);
}

module.exports = SubmitButton;
