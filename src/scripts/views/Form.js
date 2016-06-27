const Immutable = require('immutable');
const { children, cloneElement, createClass } = require('react');
const { elements } = require('react-elementary');

const PasswordInput = require('./password-input.coffee');

const { form } = elements;

const Form = createClass({
  displayName: 'Form',
  propsToState: function (props) {
    return {
      placeholders: Immutable.fromJS(props.placeholders),
      data: Immutable.fromJS(props.initialData),
    };
  },
  getDefaultProps: function () {
    return {
      action: '',
      method: 'GET',
      placeholders: {},
      initialData: {},
      error: '',
    };
  },
  getInitialState: function () {
    return this.propsToState(this.props);
  },
  keyResolver: function (k) {
    let keys = Array.isArray(k) ? k : [k];
    if (typeof this.props.keyResolver == 'function') {
      keys = this.props.keyResolver.call(this, keys);
    }
    return keys;
  },
  getPlaceholder: function (k) {
    return this.state.placeholders.getIn(this.keyResolver(k));
  },
  getValue: function (k) {
    return this.state.data.getIn(this.keyResolver(k), '');
  },
  setValue: function (k, v) {
    if (this.isMounted()) {
      this.setState({ data: this.state.data.setIn(this.keyResolver(k), v) });
    }
  },
  componentWillReceiveProps: function (nextProps) {
    this.setState(this.propsToState(nextProps));
  },
  handleChange: function ({ target }) {
    this.setValue(target.name, target.value);
  },
  handleSubmit: function (e) {
    if (typeof this.props.onSubmit == 'function') {
      e.preventDefault();
      return Promise.resolve(this.props.onSubmit(this.state.data.toJS()))
        .then(() => {
          this.setValue('error', '');
        }).catch(({ message }) => {
          this.setValue('error', message);
        });
    }
  },
  renderChild: function (child) {
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
        props.value = this.getValue(child.props.name);
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
  render: function () {
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
