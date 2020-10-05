package app.email;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

public class CustomEmail {
    private HtmlEmail email;

    public CustomEmail() throws EmailException {
        email = new HtmlEmail();
        email.setHostName("smtp.gmail.com");
        email.setSmtpPort(465);
        email.setAuthenticator(new DefaultAuthenticator("serveryzerteam@gmail.com", "t1tssqa1"));
        email.setSSLOnConnect(true);
        email.setFrom("serveryzerteam@gmail.com");
    }
    public void sendVerificationEmailBody(String receiver, String login, String token) throws EmailException {
        email.setSubject("Serveryzer email verification");
        String body = "<p>Dear " + login + ".</p>" +
                "<p>To finish registration follow this <a href=\"http://t1.tss2020.site/email_verificate?token="+token+"\">link</a>.</p><br>" +
                "<p style=\"font-style: italic;\">Your Serveryzer team</p>";
        email.setHtmlMsg(body);
        email.addTo(receiver);
        email.send();
    }
}
