package app.avatar;

import app.activecheck.ActiveCheckDao;
import app.admin.AdminController;
import app.database.DBconnectionContainer;
import app.util.RequestUtil;
import app.validate.URLValidator;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.IntNode;
import io.javalin.http.Context;
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

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.testng.Assert.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({ActiveCheckDao.class, URLValidator.class, RequestUtil.class, DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class AvatarDaoTest {

    @Test
    public void setStatus() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select verification from users where login = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("verification")).thenReturn(1);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("UPDATE users SET avatar = ? WHERE login = ?"))
                .thenReturn(statement2);


        AvatarDao.setAvatar("user", "avatar");

        verify(statement).executeQuery();
        verify(statement2).executeUpdate();
        verify(statement2).setString(1, "avatar");
        verify(statement2).setString(2, "user");
    }

    @Test
    public void getStatus() throws Exception {
        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("SELECT avatar FROM users WHERE login = ?"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getString("avatar")).thenReturn("avatar");

        String res = AvatarDao.getAvatar("login");

        assertEquals(res, "avatar");

        verify(statement).executeQuery();
    }

}