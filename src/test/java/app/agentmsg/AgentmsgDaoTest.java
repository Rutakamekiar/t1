package app.agentmsg;

import app.database.DBconnectionContainer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.testng.Assert.assertEquals;

@RunWith(PowerMockRunner.class)
@PrepareForTest({DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class AgentmsgDaoTest {

    @Test
    public void testAddAgentmsgToDB() throws SQLException, JsonProcessingException, ParseException {
        Map<String, Object> map = new HashMap<>();
        map.put("public_key", "public_key");
        map.put("host", "host");
        map.put("boot_time", "2020-04-12 21:00:00 UTC");
        map.put("at", "2020-05-09 21:00:00 UTC");

        String res = "\"{\"public_key\":\"public_key\",\"boot_time\":\"2020-04-12 21:00:00 UTC\"," +
                "\"at\":\"2020-05-09 21:00:00 UTC\",\"host\":\"host\"}\"";

        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("INSERT INTO hosts_info (\"id\", \"public_key\"," +
                " \"private_key\", \"host\" , \"boot_time\" , \"at\" , \"data\") Values (?, ? , ? , ? , ?, ? , to_json(?::json) )"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getString("data")).thenReturn("data");

        AgentmsgDao.addAgentmsgToDB("uid", map);

        verify(statement).setString(1, "uid");
        verify(statement).setString(2, "public_key");
        verify(statement).setString(3, "empty");
        verify(statement).setString(4, "host");
        verify(statement).setTimestamp(5, new Timestamp(1586725200000L));
        verify(statement).setTimestamp(6, new Timestamp(1589058000000L));

        verify(statement).execute();
    }

    @Test
    public void testGetAgentmsgFromDB() throws SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select data from hosts_info " +
                "where at < to_timestamp(?,'YYYY-MM-DD HH24:MI:SS') " +
                "and at > to_timestamp(?,'YYYY-MM-DD HH24:MI:SS') " +
                "and public_key = ? " +
                "order by at;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getString("data")).thenReturn("data");

        String expected = "{ \"data\": [ data] }";
        String res = AgentmsgDao.getAgentmsgFromDB("public_key", "from", "to");

        assertEquals(res, expected);

        verify(statement).setString(1, "to");
        verify(statement).setString(2, "from");
        verify(statement).setString(3, "public_key");
        verify(statement).executeQuery();
    }

    @Test
    public void testGetPrivateKey() throws NoSuchFieldException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select secret_key from keys where  public_key = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true).thenReturn(false);
        when(rs.getString("secret_key")).thenReturn("secret_key");

        String res = AgentmsgDao.getPrivateKey("public_key");

        assertEquals(res, "secret_key");

        verify(statement).setString(1, "public_key");
        verify(statement).executeQuery();
    }
}