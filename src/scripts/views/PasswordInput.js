const { elements } = require('react-elementary');

const { input, label } = elements;

function PasswordInput(props) {
  const type = 'password';
  const { name, onChange, value } = props;
  return label(
    { className: 'form-group' },
    `${props.label}: `,
    input({ type, name, value, onChange })
  );
}

module.exports = PasswordInput;
