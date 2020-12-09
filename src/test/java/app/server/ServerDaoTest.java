package app.server;

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

@RunWith(PowerMockRunner.class)
@PrepareForTest({DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class ServerDaoTest {

    @Test
    public void testGetUserServers() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select public_key from hosts_servers where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(true).thenReturn(false);
        when(rs.getString("public_key")).thenReturn("public_key").thenReturn("public_key");

        StringBuilder result = new StringBuilder("{ \"hosts\":[ " + "{ \"host\" :\"public_key\"}")
                .append(", { \"host\" :\"").append("public_key").append("\"}");
        result.append("] }");

        String actual = ServerDao.getUserServers("username");

        assertEquals(actual, result.toString());

        verify(statement).setString(1, "username");
        verify(statement).executeQuery();
    }

    @Test
    public void testGetUserServers_notFound() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select public_key from hosts_servers where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(false);

        String actual = ServerDao.getUserServers("username");

        assertEquals(actual, "{\"result\" : 0,\"message\": \"There are no servers\",\"hosts\":[]}");

        verify(statement).setString(1, "username");
        verify(statement).executeQuery();
    }

    @Test
    public void testAddServerToUser() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("INSERT INTO keys (public_key, secret_key) " +
                "VALUES(?,?) " +
                "ON CONFLICT (public_key) " +
                "DO " +
                "   UPDATE SET secret_key = ? ;"))
                .thenReturn(statement);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("insert into hosts_servers values ( ? , ?);"))
                .thenReturn(statement2);

        ServerDao.addServerToUser("username", "publicKey", "priviteKey");

        verify(statement).setString(1, "publicKey");
        verify(statement).setString(2, "priviteKey");
        verify(statement).setString(3, "priviteKey");
        verify(statement).executeUpdate();

        verify(statement2).setString(1, "username");
        verify(statement2).setString(2, "publicKey");
        verify(statement2).executeUpdate();
    }

    @Test
    public void testDeleteServerFromUser() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("delete from hosts_servers where login = ? and public_key = ? ;"))
                .thenReturn(statement);

        ServerDao.deleteServerFromUser("username", "publicKey");

        verify(statement).setString(1, "username");
        verify(statement).setString(2, "publicKey");
        verify(statement).execute();
    }
}