const { elements } = require('react-elementary');

const { input, label } = elements;

function RadioOption(props) {
  const type = 'radio';
  const { checked, name, onChange, value } = props;
  return label(
    { className: 'form-group--unlabeled' },
    input({ type, name, value, checked, onChange }),
    ` ${props.label}`
  );
}

module.exports = RadioOption;
