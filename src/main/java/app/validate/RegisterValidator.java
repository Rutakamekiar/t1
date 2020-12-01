package app.validate;

import org.thymeleaf.util.TextUtils;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegisterValidator {

    private static final String HTML_TAG_PATTERN = "<(\"[^\"]*\"|'[^']*'|[^'\">])+>";

    static Pattern htmlValidator = Pattern.compile(HTML_TAG_PATTERN);

    public static boolean validateHtml(final String text){
        if (text.contains("\""))
            return false;
        return !htmlValidator.matcher(text).find();
    }

    public static boolean isValidPwdLog(String pwd)
    {
        String regex = "[A-Za-z\\d_-]{6,}";
        Pattern p = Pattern.compile(regex);
        if (pwd == null) {
            return false;
        }
        Matcher m = p.matcher(pwd);
        return m.matches();
    }

    public static boolean isValidEmailAddress(String email) {
        boolean result = true;
        try {
            InternetAddress emailAddr = new InternetAddress(email);
            emailAddr.validate();
        } catch (AddressException ex) {
            result = false;
        }
        return result;
    }
}

