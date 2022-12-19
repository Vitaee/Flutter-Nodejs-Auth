const mongoose = require('mongoose');
const email_match =  /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/


const userSchema = mongoose.Schema({
    username:{
        type:String, required:true
    },
    email:{
        type:String, required:true, unique:true, match: email_match
    },
    password:{
        type:String,required:true,select:false
    },
    img:{
        data: Buffer,
        contentType: String
    },
    lastLogin: {
    type: Date,
    },

},{timestamps:true});

const User = mongoose.model('User',userSchema);

module.exports = {
    User:User,
    userSchema:userSchema
}