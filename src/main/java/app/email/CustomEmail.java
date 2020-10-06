package app.email;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

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
    private HtmlEmail email;

    /**
     * Set up main email properties
     * @throws EmailException
     */
    public CustomEmail() throws EmailException {
        email = new HtmlEmail();
        email.setHostName("smtp.gmail.com");
        email.setSmtpPort(465);
        email.setAuthenticator(new DefaultAuthenticator("serveryzerteam@gmail.com", "t1tssqa1"));
        email.setSSLOnConnect(true);
        email.setFrom("serveryzerteam@gmail.com");
    }

    /**
     * Send verification email
     * @param receiver email of receiver
     * @param login login of user
     * @param token verification token
     * @throws EmailException
     */
    public void sendVerificationEmail(String receiver, String login, String token) throws EmailException {
        email.setSubject("Serveryzer email verification");
        String body = "<p>Dear " + login + ".</p>" +
                "<p>To finish registration follow this <a href=\"http://t1.tss2020.site/email_verificate?token="+token+"\">link</a>.</p><br>" +
                "<p style=\"font-style: italic;\">Your Serveryzer team.</p>";
        email.setHtmlMsg(body);
        email.addTo(receiver);
        email.send();
    }

    /**
     * Send email with new password
     * @param receiver email of receiver
     * @param newPwd new password to send
     * @throws EmailException
     */
    public void sendDropPwdEmail(String receiver, String newPwd) throws EmailException {
        email.setSubject("Serveryzer drop password");
        String body = "<p>Dear user.</p>" +
                "<p>You dropped password.</p>" +
                "<p>Your new password: <span style=\"font-style: italic; text-decoration: underline;\">"+newPwd+"</span></p>"+
                "<br><p style=\"font-style: italic;\">Your Serveryzer team.</p>";
        email.setHtmlMsg(body);
        email.addTo(receiver);
        email.send();
    }
}
