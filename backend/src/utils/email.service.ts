import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: 'smtp.example.com',
  port: 587, // or 465 for secure SMTP
  secure: false, // true for 465, false for other ports
  auth: {
    user: 'constructionmsystem@gmail.com',
    pass: 'jrprofedhrugnavb',
  },
});

export const sendInvitationEmail = async (email: string, token: string) => {
  const registrationLink = `yourapp://register?token=${token}`;
  const mailOptions = {
    from: '"Construction Management System" <your-email@example.com>',
    to: email,
    subject: 'Invitation to join our Construction Management System',
    text: `Please use the following link to complete your registration: ${registrationLink}`,
    html: `
      <html>
      <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
        <table width="100%" style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
          <tr>
            <td style="background-color: #007BFF; padding: 20px; color: #ffffff; text-align: center; border-top-left-radius: 8px; border-top-right-radius: 8px;">
              <h1 style="margin: 0; font-size: 24px;">Welcome to the Construction Management System!</h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 20px; text-align: center;">
              <p style="font-size: 18px; color: #333333; margin: 0 0 20px;">We are excited to have you on board.</p>
              <p style="font-size: 16px; color: #555555; margin: 0 0 20px;">Please use the button below to complete your registration and get started:</p>
              <a href="${registrationLink}" style="display: inline-block; padding: 10px 20px; font-size: 16px; color: #ffffff; background-color: #007BFF; text-decoration: none; border-radius: 5px; margin: 20px 0;">Complete Registration</a>
              <p style="font-size: 14px; color: #777777; margin: 20px 0 0;">If the button above doesn't work, please use the following link:</p>
              <a href="${registrationLink}" style="font-size: 14px; color: #007BFF; word-break: break-all;">${registrationLink}</a>
            </td>
          </tr>
          <tr>
            <td style="background-color: #f4f4f4; padding: 10px; text-align: center; border-bottom-left-radius: 8px; border-bottom-right-radius: 8px;">
              <p style="font-size: 12px; color: #777777; margin: 5px 0 0;">&copy; 2024 Construction Management System. All rights reserved.</p>
            </td>
          </tr>
        </table>
      </body>
      </html>
    `,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`Email sent: ${info.messageId}`);
  } catch (error) {
    console.error(`Error sending email: ${error}`);
  }
};
