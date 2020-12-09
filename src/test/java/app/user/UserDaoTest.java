package app.user;


import org.junit.Test;

import java.util.List;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertNotNull;

public class UserDaoTest {

    @Test
    public void testGetUserByUsername() {
        UserDao userDao = new UserDao();
        User user = userDao.getUserByUsername("perwendel");

        assertNotNull(user);
    }

    @Test
    public void testGetAllUserNames() {
        UserDao userDao = new UserDao();
        List<String> users = (List<String>) userDao.getAllUserNames();

        assertEquals(users.size(), 3);
    }
}