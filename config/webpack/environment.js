const { environment } = require('@rails/webpacker')
const resolve = require('./loaders/resolve');

environment.loaders.get('sass').use.splice(-1, 0, resolve);

module.exports = environment
