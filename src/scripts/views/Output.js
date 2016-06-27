const { elements } = require('react-elementary');

const { label, output } = elements;

function Output(props) {
  const { name, value } = props;
  return label(
    { className: 'form-group' },
    `${props.label}: `,
    output({ name }, value)
  );
}

module.exports = Output;
