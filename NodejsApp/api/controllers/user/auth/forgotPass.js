import { User } from '../../../models/user/index.js';
import crypto from 'crypto';
import { sendEmail } from '../../../../utils/sendEmail.js';
import bcryptjs from 'bcryptjs';
import async from "async"

const forgetPassword = async (req, res) => {
    const user = await User.findOne({ email: req.body.email })

    const resetToken = crypto.randomBytes(20).toString('hex')
    user.resetPasswordToken = crypto.createHash('sha256').update(resetToken).digest('hex')
    user.resetPasswordExpire = Date.now() + 10 * 60 * 1000;

    await user.save()
    
    const message = `You're receiving this email because you requested the resef of your password.
    Here is link \n ${req.protocol}://${req.get('host')}/resetPassword/${resetToken}/`


    
    const emailQueue = async.queue( (data, callback) => {

        sendEmail(data, (err) => {
            if (err) console.log(err)
            callback();
        });

    }, 1);
    
    emailQueue.push({ email: req.body.email, subject: 'Reset Password', message: message })
    
    return res.status(200).json({'msg': 'Success!'})

}

const resetPassword = async(req,res) => {
    const resetPasswordToken = crypto.createHash('sha256').update(req.query.resetToken).digest('hex')

    const user = await User.findOne({
        resetPasswordToken: resetPasswordToken,
        resetPasswordExpire: { $gt: Date.now() }
    });
  
    if (!user) return res.status(403).json({'msg' : 'Your reset password token expired try again with new request!'})
    
    const hash = await bcryptjs.hash(req.body.password, 10);
    user.password = hash
    user.resetPasswordToken = "";
    user.resetPasswordExpire = "";

    await user.save()

    return res.status(200).json({'msg': 'Successfully resetted your password!'})
}

export { forgetPassword, resetPassword }