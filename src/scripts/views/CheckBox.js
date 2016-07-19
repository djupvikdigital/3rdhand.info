const { elements } = require('react-elementary').default;

const { input, label } = elements;

function CheckBox(props) {
  const { name, onChange, value } = props;
  return label(
    `${props.label}: `,
    input({ type: 'checkbox', name, onChange, value })
  );
}

module.exports = CheckBox;
