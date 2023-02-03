import mongoose from 'mongoose';
const email_match =  /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/


const userSchema =  mongoose.Schema({
    username:{
        type:String, required:true
    },
    email:{
        type:String, required:true, unique:true, match: email_match
    },
    password:{
        type:String,required:true,select:false
    },
    profileImage:{
        type: String
    },
    bio: {
        type: String
    },
    lastLogin: {
        type: Date,
    },
    resetPasswordToken: {
        type: String
    },
    resetPasswordExpire: {
        type: Date
    }

},{timestamps:true});

const User = mongoose.model('User',userSchema);

userSchema.methods.getResetPasswordToken =  () => {
    const resetToken = crypto.randomBytes(20).toString('hex')
    console.log(resetToken)
    this.resetPasswordToken = crypto.createHash('sha256').update(resetToken).digest('hex')
    this.resetPasswordExpire = Date.now() + 10 * 60 * 1000;
    return resetToken;
}

export { User, userSchema } 