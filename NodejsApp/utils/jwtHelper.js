import jsonwebtoken from 'jsonwebtoken';
import * as dotenv from 'dotenv'
dotenv.config()
export async function signAccessToken(userId) {
    console.log(userId)
    const authorization = jsonwebtoken.sign({ _id: userId }, process.env.JWT_SECRET_KEY, { expiresIn: '2h' });
    console.log(authorization)
    return authorization;
}