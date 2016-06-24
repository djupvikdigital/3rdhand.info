const logger = require('./log.js');

function authenticationErrorHandler(res, error) {
  logger.warn(error.message);
  return res.status(400).send({ message: 'invalid email or password' });
}

function changePasswordErrorHandler(res, { message }) {
  logger.warn(message);
  return res.status(400).send({ message });
}

function defaultErrorHandler(res, error) {
  logger.error(error);
  return res.sendStatus(500);
}

function handleError(res, error) {
  return (errorHandlers[error.message] || errorHandlers.default)(res, error);
}

function invalidLoginErrorHandler(res, { message }) {
  logger.warn(message);
  return res.sendStatus(400);
}

function noEmailProvidedErrorHandler(res, { message }) {
  logger.warn(message);
  return res.status(400).send({ message });
}

function noRouteMatchErrorHandler(res) {
  return res.sendStatus(404);
}

function notLoggedInErrorHandler(res, { message }) {
  logger.warn(message);
  return res.sendStatus(404);
}

function permissionDeniedErrorHandler(res, { message }) {
  logger.warn(message);
  return res.sendStatus(403);
}

const errorHandlers = {
  'authetication failed': authenticationErrorHandler,
  'default': defaultErrorHandler,
  'invalid login': invalidLoginErrorHandler,
  'login required': notLoggedInErrorHandler,
  'no email provided': noEmailProvidedErrorHandler,
  'no route match': noRouteMatchErrorHandler,
  'no user match': authenticationErrorHandler,
  'permmission denied': permissionDeniedErrorHandler,
  'repeat password mismatch': changePasswordErrorHandler,
  'required fields missing': changePasswordErrorHandler,
};

module.exports = handleError;
