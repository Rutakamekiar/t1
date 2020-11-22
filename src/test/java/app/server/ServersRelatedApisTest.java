package app.server;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ServersRelatedApisTest {

    @Test
    public void testMethodIsAllowedToAddServer() throws JsonProcessingException {
        assertEquals (false, ServerDao.isAllowedToAddServer("{ \"hosts\":[ { \"host\" :\"test_p\"}, { \"host\" :\"test3\"}] }", 1));
        assertEquals (true, ServerDao.isAllowedToAddServer("{ \"hosts\":[ { \"host\" :\"test_p\"}, { \"host\" :\"test3\"}] }", 2));
        assertEquals (true, ServerDao.isAllowedToAddServer("{ \"hosts\":[ { \"host\" :\"test3\"}] }", 1));
    }

}
