package app.customer;

import app.login.Customer;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CustomerUtilTest {
    @Test
    public void intToStringStatusTest(){
        assertEquals(Customer.intStatusToString(1),"free");
        assertEquals(Customer.intStatusToString(2),"premium");
        assertEquals(Customer.intStatusToString(3),"admin");
        assertEquals(Customer.intStatusToString(4),"strange status");
        assertNotEquals(Customer.intStatusToString(1),"admin");
    }
}
