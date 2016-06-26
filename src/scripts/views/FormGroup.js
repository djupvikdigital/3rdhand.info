const React = require('react');
const { elements } = require('react-elementary');

const { div, label } = elements;

function FormGroup(_props) {
  const childTypes = [];
  let hasTextChild = false;
  React.Children.forEach(_props.children, child => {
    const type = typeof child;
    childTypes[childTypes.length] = type;
    if (type === 'string') {
      hasTextChild = true;
    }
  });
  let props = {
    className: 'form-group',
  };
  if (childTypes[0] !== 'string') {
    props.className += '--unlabeled';
  }
  props = Object.assign({}, props, _props);
  if (hasTextChild) {
    return label(props);
  }
  return div(props);
}

module.exports = FormGroup;
