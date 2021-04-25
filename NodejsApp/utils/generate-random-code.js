const randomstring = require('randomstring');

module.exports = () => randomstring.generate({ length: 4, charset: 'numeric' });