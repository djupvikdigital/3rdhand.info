const Immutable = require('immutable');
const { Children, cloneElement, createClass } = require('react');
const { elements } = require('react-elementary');

const PasswordInput = require('./PasswordInput.js');

const { form } = elements;

const Form = createClass({
  displayName: 'Form',
  propsToState: function propsToState(props) {
    return {
      placeholders: Immutable.fromJS(props.placeholders),
      data: Immutable.fromJS(props.initialData),
    };
  },
  getDefaultProps: function getDefaultProps() {
    return {
      action: '',
      method: 'GET',
      placeholders: {},
      initialData: {},
      error: '',
    };
  },
  getInitialState: function getInitialState() {
    return this.propsToState(this.props);
  },
  keyResolver: function keyResolver(k) {
    let keys = Array.isArray(k) ? k : [k];
    if (typeof this.props.keyResolver == 'function') {
      keys = this.props.keyResolver.call(this, keys);
    }
    return keys;
  },
  getPlaceholder: function getPlaceholder(k) {
    return this.state.placeholders.getIn(this.keyResolver(k));
  },
  getValue: function getValue(k, v = '') {
    return this.state.data.getIn(this.keyResolver(k), v);
  },
  setValue: function setValue(k, v) {
    if (this.isMounted()) {
      this.setState({ data: this.state.data.setIn(this.keyResolver(k), v) });
    }
  },
  removeValue: function removeValue(k) {
    if (this.isMounted()) {
      this.setState({ data: this.state.data.deleteIn(this.keyResolver(k)) });
    }
  },
  componentWillReceiveProps: function componentWillReceiveProps(nextProps) {
    this.setState(this.propsToState(nextProps));
  },
  handleChange: function handleChange({ target }) {
    const { checked, name, value } = target;
    if (!Object.prototype.hasOwnProperty.call(target, 'checked') || checked) {
      this.setValue(name, value);
    }
    else {
      this.removeValue(name);
    }
  },
  handleSubmit: function handleSubmit(e) {
    if (typeof this.props.onSubmit == 'function') {
      e.preventDefault();
      return Promise.resolve(this.props.onSubmit(this.state.data.toJS()))
        .then(() => {
          this.setValue('error', '');
        }).catch(({ message }) => {
          this.setValue('error', message);
        });
    }
    return Promise.resolve(null);
  },
  renderChild: function renderChild(child) {
    if (!child.props) {
      return child;
    }
    let children;
    if (child.props.children) {
      children = Children.map(child.props.children, this.renderChild, this);
    }
    if (child.props.name) {
      const props = {
        onChange: this.handleChange,
      };
      if (child.type !== PasswordInput) {
        props.value = this.getValue(child.props.name, child.props.value);
      }
      const placeholder = this.getPlaceholder(child.props.name);
      if (placeholder) {
        props.placeholder = placeholder;
      }
      if (children) {
        return cloneElement(child, props, children);
      }
      return cloneElement(child, props);
    }
    else if (children) {
      return cloneElement(child, {}, children);
    }
    return child;
  },
  render: function render() {
    return form(
      {
        action: this.props.action,
        method: this.props.method,
        onSubmit: this.handleSubmit,
      },
      Children.map(this.props.children, this.renderChild, this)
    );
  },
});

module.exports = Form;
