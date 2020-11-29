package app.customer;

import app.login.Customer;
import app.login.SignIn;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CustomerTest {

    @Test
    public void checkAuthenticate(){
        assertTrue(SignIn.authenticate(new Customer("testUser","test1234","free"),"test1234"));
        assertFalse(SignIn.authenticate(new Customer("testUser","test1234","free"),"test1235"));
    }
}
