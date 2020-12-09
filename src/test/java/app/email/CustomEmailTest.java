package app.email;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import java.io.IOException;
import java.lang.reflect.Field;

import static org.mockito.Mockito.mock;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.testng.Assert.assertEquals;

@RunWith(PowerMockRunner.class)
@PrepareForTest(Transport.class)
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class CustomEmailTest {

    @Test
    public void sendVerifEmailEn() throws MessagingException, IOException, NoSuchFieldException, IllegalAccessException {
        Message email = mock(Message.class);
        CustomEmail customEmail = new CustomEmail();
        mockStatic(Transport.class);

        customEmail.sendVerificationEmail("receiver", "login", "token", "en");

        Field f = CustomEmail.class.getDeclaredField("email");
        f.setAccessible(true);
        Message value = (Message) f.get(customEmail);
        assertEquals(value.getSubject(), "Serveryzer email verification");
        assertEquals(value.getContent(), "<p>Dear login.</p>" +
                "<p>To finish registration follow this <a href=\"https://t1.tss2020.site/email_verificate?" +
                "token=token\">link</a>.</p><br>" +
                "<p style=\"font-style: italic;\">Your Serveryzer team.</p>");
    }

    @Test
    public void sendVerifEmailUa() throws MessagingException, IOException, NoSuchFieldException, IllegalAccessException {
        Message email = mock(Message.class);
        CustomEmail customEmail = new CustomEmail();
        mockStatic(Transport.class);

        customEmail.sendVerificationEmail("receiver", "login", "token", "ua");

        Field f = CustomEmail.class.getDeclaredField("email");
        f.setAccessible(true);
        Message value = (Message) f.get(customEmail);
        assertEquals(value.getSubject(), "Верифікація аккаунту Serveryzer");
        assertEquals(value.getContent(), "<p>Шановний login.</p>" +
                "<p>Для завершення реєстрації перейдіть за <a href=\"https://t1.tss2020.site/email_verificate?" +
                "token=token\">посиланням</a>.</p><br>" +
                "<p style=\"font-style: italic;\">Ваша команда Serveryzer.</p>");
    }

    @Test
    public void sendDropPwdEmailEn() throws MessagingException, IOException, NoSuchFieldException, IllegalAccessException {
        CustomEmail customEmail = new CustomEmail();
        mockStatic(Transport.class);

        customEmail.sendDropPwdEmail("receiver", "newPwd", "en");

        Field f = CustomEmail.class.getDeclaredField("email");
        f.setAccessible(true);
        Message value = (Message) f.get(customEmail);
        assertEquals(value.getSubject(), "Serveryzer drop password");
        assertEquals(value.getContent(), "<p>Dear user.</p>" +
                "<p>You dropped password.</p>" +
                "<p>Your new password: <span style=\"font-style: italic; text-decoration: underline;\">newPwd</span></p>" +
                "<br><p style=\"font-style: italic;\">Your Serveryzer team.</p>");
    }

    @Test
    public void sendDropPwdEmailUa() throws MessagingException, IOException, NoSuchFieldException, IllegalAccessException {
        CustomEmail customEmail = new CustomEmail();
        mockStatic(Transport.class);

        customEmail.sendDropPwdEmail("receiver", "newPwd", "ua");

        Field f = CustomEmail.class.getDeclaredField("email");
        f.setAccessible(true);
        Message value = (Message) f.get(customEmail);
        assertEquals(value.getSubject(), "Скидання паролю аккакунту Serveryzer");
        assertEquals(value.getContent(), "<p>Шановний користувач.</p>" +
                "<p>Ви скинули свій пароль.</p>" +
                "<p>Ваш новий пароль: <span style=\"font-style: italic; text-decoration: underline;\">newPwd</span></p>" +
                "<br><p style=\"font-style: italic;\">Ваша команда Serveryzer.</p>");
    }
}