package app.validate;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ValidateTest {
    @Test
    public void testURLValidator() {
        assertTrue(URLValidator.isValidURL("http://t1.tss2020.site"));
        assertTrue(URLValidator.isValidURL("https://t1.tss2020.site"));
        assertFalse(URLValidator.isValidURL("t1.tss2020.site"));
        assertFalse(URLValidator.isValidURL("https://t1"));
        assertFalse(URLValidator.isValidURL(""));
        assertFalse(URLValidator.isValidURL(null));
    }

    @Test
    public void testPwdLoginValidator() {
        assertTrue(RegisterValidator.isValidPwdLog("t1_tss"));
        assertTrue(RegisterValidator.isValidPwdLog("t2-tss"));
        assertTrue(RegisterValidator.isValidPwdLog("t2-TSS"));
        assertTrue(RegisterValidator.isValidPwdLog(""));
        assertTrue(RegisterValidator.isValidPwdLog("t2"));
        assertTrue(RegisterValidator.isValidPwdLog("t2*tss"));
        assertFalse(RegisterValidator.isValidPwdLog(null));
        assertFalse(RegisterValidator.isValidPwdLog("\"smth"));
    }

    @Test
    public void testEmailValidator() {
        assertTrue(RegisterValidator.isValidEmailAddress("t1-tss@gmail.com"));
        assertTrue(RegisterValidator.isValidEmailAddress("t1-tss@gmail.com.ua"));
        assertFalse(RegisterValidator.isValidEmailAddress(""));
        assertFalse(RegisterValidator.isValidEmailAddress("t2"));
        assertFalse(RegisterValidator.isValidEmailAddress("t1-tss @gmail.com.ua"));
    }

    @Test
    public void testHtmlValidator(){
        assertTrue(RegisterValidator.validateHtml("t1_tss"));
        assertTrue(RegisterValidator.validateHtml("t1_tss<>"));
        assertFalse(RegisterValidator.validateHtml("<script>alert(1)</script>"));
        assertFalse(RegisterValidator.validateHtml("alert(\"xss\")"));
    }
}
