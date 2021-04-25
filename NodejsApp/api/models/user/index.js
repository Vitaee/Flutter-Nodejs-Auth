const userModel = require('./userModel');
const userValidate = require('./userValidate');

module.exports = {
    User:userModel.User,
    userSchema: userModel.userSchema,
    userValidate:userValidate,
};