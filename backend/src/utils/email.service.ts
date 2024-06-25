import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: 'smtp.example.com', // e.g., 'smtp.gmail.com' for Gmail
  port: 587, // or 465 for secure SMTP
  secure: false, // true for 465, false for other ports
  auth: {
    user: 'your-email@example.com', // your email address
    pass: 'your-email-password', // your email password or app-specific password
  },
});

export const sendInvitationEmail = async (email: string, token: string) => {
  const registrationLink = `yourapp://register?token=${token}`;
  const mailOptions = {
    from: '"Construction Management System" <your-email@example.com>',
    to: email,
    subject: 'Invitation to join our Construction Management System',
    text: `Please use the following link to complete your registration: ${registrationLink}`,
    html: `<p>Please use the following link to complete your registration: <a href="${registrationLink}">${registrationLink}</a></p>`,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`Email sent: ${info.messageId}`);
  } catch (error) {
    console.error(`Error sending email: ${error}`);
  }
};
