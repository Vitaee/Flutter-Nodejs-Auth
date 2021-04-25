const errorJson = require('../../../utils/error');
const {User} = require('../../models/user');

module.exports = async (req,res,next) => {
    const hasEmail = await User.findOne({email:req.body.email}).catch((err) => {
        return res
            .status(500)
            .json(errorJson(err.message,'An interval server error while finding duplicate email.'))
    });

    if (hasEmail){
        return res
            .status(409)
            .json(errorJson("Duplicate Email","An account with this email address already exists."));
    }

    next();


};