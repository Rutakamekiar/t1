package app.register;

import app.database.DBconnectionContainer;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertFalse;
import static org.testng.Assert.assertTrue;

@RunWith(PowerMockRunner.class)
@PrepareForTest({DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class RegisterDaoTest {

    @Test
    public void testInsertRegisterTrue() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select * from users where email = ? or login = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(false);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("insert into users (login, email, pwd, status, verification, " +
                "ver_token) values (?, ?, ?, ?, ?, ?)"))
                .thenReturn(statement2);

        assertTrue(RegisterDao.insertRegister("email", "login", "pwd", "token"));

        verify(statement).setString(1, "email");
        verify(statement).setString(2, "login");
        verify(statement).executeQuery();

        verify(statement2).setString(1, "login");
        verify(statement2).setString(2, "email");
        verify(statement2).setString(3, "pwd");
        verify(statement2).setInt(4,1);
        verify(statement2).setInt(5,0);
        verify(statement2).setString(6, "token");
        verify(statement2).executeUpdate();
    }

    @Test
    public void testInsertRegisterFalse() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select * from users where email = ? or login = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);

        assertFalse(RegisterDao.insertRegister("email", "login", "pwd", "token"));

        verify(statement).setString(1, "email");
        verify(statement).setString(2, "login");
        verify(statement).executeQuery();
    }

    @Test
    public void testVerifyEmail() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set verification = 1 where ver_token = ?"))
                .thenReturn(statement);

        RegisterDao.verifyEmail("token");

        verify(statement).setString(1, "token");
        verify(statement).executeUpdate();
    }

    @Test
    public void testDropPass_checkEmail() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select verification, status from users where email = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getInt("status")).thenReturn(4);
        when(rs.getInt("verification")).thenReturn(1);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set pwd = ? where email = ?"))
                .thenReturn(statement2);

        String actual = RegisterDao.dropPass("email", "newPassword");

        assertEquals(actual, "{\"result\" : 2,\"message\": \"Password dropped check email\"}");

        verify(statement).executeQuery();

        verify(statement2).setString(1, "newPassword");
        verify(statement2).setString(2, "email");
        verify(statement2).executeUpdate();
    }

    @Test
    public void testDropPass_adminStatus() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select verification, status from users where email = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getInt("status")).thenReturn(3);
        when(rs.getInt("verification")).thenReturn(1);

        String actual = RegisterDao.dropPass("email", "newPassword");

        assertEquals(actual, "{\"result\" : 0,\"message\": \"Cannot drop admin password\"}");

        verify(statement).executeQuery();
    }

    @Test
    public void testDropPass_emailNonVerified() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select verification, status from users where email = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getInt("status")).thenReturn(4);
        when(rs.getInt("verification")).thenReturn(0);

        String actual = RegisterDao.dropPass("email", "newPassword");

        assertEquals(actual, "{\"result\" : 0,\"message\": \"Email is not verified\"}");

        verify(statement).executeQuery();
    }

    @Test
    public void testDropPass_notFound() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select verification, status from users where email = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(false);

        String actual = RegisterDao.dropPass("email", "newPassword");

        assertEquals(actual, "{\"result\" : 0,\"message\": \"Such email does not exist\"}");

        verify(statement).executeQuery();
    }
}