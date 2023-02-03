import nodemailer from 'nodemailer';
import * as dotenv from 'dotenv'
dotenv.config()

const sendEmail = async (options) => {

    let transporter = nodemailer.createTransport({
        service: process.env.MAIL_SERVICE,
        host: process.env.MAIL_HOST,
        auth: {
            user: process.env.MAIL_USER,
            pass: process.env.MAIL_PASS
        },
    });

    let message = {
        from: process.env.MAIL_USER,
        to: options.email,
        subject: options.subject,
        text: options.message
    };

    const info = await transporter.sendMail(message)

    console.log("Message sent: ", info.messageId)
}

export { sendEmail }