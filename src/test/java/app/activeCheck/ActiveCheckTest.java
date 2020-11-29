package app.activeCheck;

import app.activecheck.ActiveCheck;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ActiveCheckTest {
    @Test
    public void testConnection() throws IOException {
        assertEquals(ActiveCheck.checkUrl("https://www.google.com/"),200);
        assertEquals(ActiveCheck.checkUrl("https://www.google.com/smth"),404);
    }
}
