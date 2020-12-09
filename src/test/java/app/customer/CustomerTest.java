package app.customer;

import app.database.DBconnectionContainer;
import app.login.Customer;
import app.login.SignIn;
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

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.testng.Assert.assertEquals;

@RunWith(PowerMockRunner.class)
@PrepareForTest({DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class CustomerTest {

    @Test
    public void checkAuthenticate(){
        assertTrue(SignIn.authenticate(new Customer("testUser","test1234","free"),"test1234"));
        assertFalse(SignIn.authenticate(new Customer("testUser","test1234","free"),"test1235"));
        assertFalse(SignIn.authenticate(new Customer(null,"test1234","free"),"test1235"));
        assertFalse(SignIn.authenticate(new Customer("testUser","test1234",null),null));
    }

    @Test
    public void getCustomerFromDb_verif1() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select pwd , verification, status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getInt("verification")).thenReturn(1);
        when(rs.getInt("status")).thenReturn(2);
        when(rs.getString("pwd")).thenReturn("pwd");

        Customer res = Customer.getCustomerFromDB("login");

        assertEquals(res.getLogin(), "login");
        assertEquals(res.getPassword(), "pwd");
        assertEquals(res.getStatus(), "premium");

        verify(statement).setString(1, "login");
        verify(statement).executeQuery();
    }

    @Test(expected = ExceptionInInitializerError.class)
    public void getCustomerFromDb_verif0() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select pwd , verification, status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getInt("verification")).thenReturn(0);

        Customer.getCustomerFromDB("login");
    }

    @Test(expected = NoSuchFieldException.class)
    public void getCustomerFromDb_noRes() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select pwd , verification, status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(false);

        Customer.getCustomerFromDB("login");
    }

    @Test
    public void generateKeys() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("insert into PremiumKeys values (?);"))
                .thenReturn(statement);

        Customer.generateKeys();

        verify(statement, times(10)).setString(anyInt(), anyString());
        verify(statement, times(10)).execute();
    }

    @Test
    public void validateUserCode_true() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select login from PremiumKeys where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);

        boolean actual = Customer.validateUserCode("code");
        assertTrue(actual);

        verify(statement).setString(1, "code");
    }

    @Test
    public void validateUserCode_false() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select login from PremiumKeys where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(false);

        boolean actual = Customer.validateUserCode("code");
        assertFalse(actual);

        verify(statement).setString(1, "code");
    }

    @Test
    public void providePremium() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement1 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set status = 2 where login = ?;"))
                .thenReturn(statement1);
        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("delete from PremiumKeys where login = ?;"))
                .thenReturn(statement2);

        Customer.providePremium("username", "code");

        verify(statement1).setString(1, "username");
        verify(statement2).setString(1, "code");
        verify(statement1).execute();
        verify(statement2).execute();
    }
}
