const JWT = require('jsonwebtoken');
require('dotenv').config();

module.exports = {
    signAccessToken: async (userId) => {
        const authorization = await JWT.sign({_id: userId}, process.env.JWT_SECRET_KEY,{expiresIn: '2h'});
        return authorization;
    }
}