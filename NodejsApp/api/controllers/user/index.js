const register = require('./auth/register');
const login = require('./auth/login');
const getUser = require('./getUser');
module.exports = {
    register: register,
    login:login,
    getUser:getUser,
}