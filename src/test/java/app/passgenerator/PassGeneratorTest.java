package app.passgenerator;

import app.util.PasswordGenerator;
import app.validate.RegisterValidator;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PassGeneratorTest {
    @Test
    public void testPwdGenerator() {
        assertTrue(RegisterValidator.isValidPwdLog(PasswordGenerator.generatePassword(8)));
        assertTrue(RegisterValidator.isValidPwdLog(PasswordGenerator.generatePassword(6)));
        //assertFalse(RegisterValidator.isValidPwdLog(PasswordGenerator.generatePassword(4)));
    }
}
