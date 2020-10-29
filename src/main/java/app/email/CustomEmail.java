package app.email;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Class to work with email
 * @author Zhuravlev Yuriu
 * @version 1.0
 */
public class CustomEmail {
    /**
     * Field of email
     * @see HtmlEmail
     */
    private Message email;

    /**
     * Set up main email properties
     * @throws EmailException
     */
    public CustomEmail() throws MessagingException  {
        final String username = "serveryzerteam@gmail.com";
        final String password = "hwvbnfyetvlgkkgm";
        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        Session session = Session.getInstance(prop,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });
        email = new MimeMessage(session);
        email.setFrom(new InternetAddress("serveryzerteam@gmail.com"));
        /*email = new HtmlEmail();
        email.setHostName("smtp.gmail.com");
        email.setSmtpPort(587);
        email.setAuthenticator(new DefaultAuthenticator("serveryzerteam@gmail.com", "t1tssqa1"));
        email.setStartTLSEnabled(true);
        email.setFrom("serveryzerteam@gmail.com");*/
    }

    /**
     * Send verification email
     * @param receiver email of receiver
     * @param login login of user
     * @param token verification token
     * @throws EmailException
     */
    public void sendVerificationEmail(String receiver, String login, String token) throws MessagingException {
        email.setSubject("Serveryzer email verification");
        String body = "<p>Dear " + login + ".</p>" +
                "<p>To finish registration follow this <a href=\"https://t1.tss2020.site/email_verificate?token="+token+"\">link</a>.</p><br>" +
                "<p style=\"font-style: italic;\">Your Serveryzer team.</p>";
        email.setContent(body, "text/html; charset=utf-8");
        email.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(receiver)
        );
        Transport.send(email);
    }

    /**
     * Send email with new password
     * @param receiver email of receiver
     * @param newPwd new password to send
     * @throws EmailException
     */
    public void sendDropPwdEmail(String receiver, String newPwd) throws MessagingException {
        email.setSubject("Serveryzer drop password");
        String body = "<p>Dear user.</p>" +
                "<p>You dropped password.</p>" +
                "<p>Your new password: <span style=\"font-style: italic; text-decoration: underline;\">"+newPwd+"</span></p>"+
                "<br><p style=\"font-style: italic;\">Your Serveryzer team.</p>";
        email.setContent(body, "text/html; charset=utf-8");
        email.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(receiver)
        );
        Transport.send(email);
    }
}
