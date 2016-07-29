const { connect } = require('react-redux');
const { createFactory, elements } = require('react-elementary');

const actions = require('../actions/localeActions.js');
const selector = require('../selectors/appSelectors.js').linkSelector;

const Link = createFactory(connect(selector)(require('./Link.js')));

const { li, nav, ul } = elements;

function propFactory(props, langParam) {
  const onClick = function onClick() {
    props.dispatch(actions.fetchStrings(langParam));
  };
  return { langParam, onClick };
}

function LangPicker(props) {
  const classes = ['lang-picker'];
  if (props.className) {
    classes[classes.length] = props.className;
  }
  const { english, norwegian } = props.localeStrings;
  return nav(
    { className: classes.join(' ') },
    ul(
      { className: 'list-inline' },
      li(Link(propFactory(props, 'no'), norwegian)),
      li(Link(propFactory(props, 'en'), english))
    )
  );
}

module.exports = LangPicker;
