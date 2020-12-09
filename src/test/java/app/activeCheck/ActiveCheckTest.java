package app.activeCheck;

import app.activecheck.ActiveCheck;
import app.database.DBconnectionContainer;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.mockStatic;

@RunWith(PowerMockRunner.class)
@PrepareForTest(DBconnectionContainer.class)
@PowerMockIgnore({"com.sun.org.apache.xerces.*", "javax.xml.*", "org.xml.*", "org.w3c.*", "org.mockito.*"})
public class ActiveCheckTest {

    @Test
    public void testConnection() throws IOException {
        assertEquals(ActiveCheck.checkUrl("https://www.google.com/"),200);
        assertEquals(ActiveCheck.checkUrl("https://www.google.com/smth"),404);
    }

    @Test
    public void testCheckAll() throws IOException, SQLException {
        mockStatic(DBconnectionContainer.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        when(connection.prepareStatement("select distinct url from user_link;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next())
                .thenReturn(true)
                .thenReturn(false);
        when(rs.getString(1)).thenReturn("https://www.google.com/");

        when(connection.prepareStatement("insert into checks(url,check_date,status) values(?,current_timestamp,?);"))
                .thenReturn(statement);

        ActiveCheck.checkAllUrl();

        verify(statement).setString(1, "https://www.google.com/");
        verify(statement).setInt(2, 200);
        verify(statement).executeUpdate();
    }
}
