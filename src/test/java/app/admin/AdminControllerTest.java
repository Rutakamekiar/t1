package app.admin;

import app.activecheck.ActiveCheckDao;
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

@RunWith(PowerMockRunner.class)
@PrepareForTest({ActiveCheckDao.class, URLValidator.class, RequestUtil.class, DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class AdminControllerTest {

    @Test
    public void getAllUsersNullUsernameCookieTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AdminController.getAllUsersAdmin.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setPremiumUserNullUsernameCookieTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AdminController.setPremiumUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void dropAvatarNullUsernameCookieTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AdminController.dropAvatar.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void dropUserHostsNullUsernameCookieTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AdminController.dropUserHosts.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setFreeUserNullUsernameCookieTest() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AdminController.setFreeUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getAllUsersStatusNot3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(4);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"))
                .thenReturn(node);
        AdminController.getAllUsersAdmin.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setFreeUserStatusNot3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(4);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"))
                .thenReturn(node);
        AdminController.setFreeUser.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void dropUserHostsStatusNot3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(4);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"))
                .thenReturn(node);
        AdminController.dropUserHosts.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void dropAvatarStatusNot3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(4);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"))
                .thenReturn(node);
        AdminController.dropAvatar.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setPremiumUserStatusNot3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(4);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"))
                .thenReturn(node);
        AdminController.setPremiumUser.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getAllUsersStatus3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(3);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select login, status, verification, case when avatar" +
                " is null then 'empty' else 'not empty' end as av from users where status != 3"))
                .thenReturn(statement2);
        ResultSet rs2 = mock(ResultSet.class);
        when(statement2.executeQuery()).thenReturn(rs2);
        when(rs2.next()).thenReturn(true).thenReturn(false);
        when(rs2.getInt("status")).thenReturn(1);
        when(rs2.getString("login")).thenReturn("login");
        when(rs2.getString("av")).thenReturn("av");

        String resJson = "{\"result\" : 1, \"message\": \"all users\", \"users\" : [{ \"login\": \"login\", \"user-status\": " +
                "\"free\", \"verification-status\": \"not verificated\", \"avatar\": \"av\" }]}";

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson)).thenReturn(node);
        AdminController.getAllUsersAdmin.handle(ctx);

        verify(statement).executeQuery();
        verify(ctx).json(node);
        verify(ctx).status(201);
    }

    @Test
    public void setPremiumUserStatus3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("login")).thenReturn("login");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(3);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set status = ? where login = ? and status != 3"))
                .thenReturn(statement2);

        String resJson = "{\"result\" : 1,\"message\": \"premium status updated\"}";

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson)).thenReturn(node);
        AdminController.setPremiumUser.handle(ctx);

        verify(statement2).setInt(1, 2);
        verify(statement2).setString(2, "login");
        verify(statement2).executeUpdate();
        verify(ctx).json(node);
        verify(ctx).status(201);
    }

    @Test
    public void setFreeUserStatus3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("login")).thenReturn("login");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(3);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set status = ? where login = ? and status != 3"))
                .thenReturn(statement2);

        String resJson = "{\"result\" : 1,\"message\": \"free status updated\"}";

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson)).thenReturn(node);
        AdminController.setFreeUser.handle(ctx);

        verify(statement2).setInt(1, 1);
        verify(statement2).setString(2, "login");
        verify(statement2).executeUpdate();
        verify(ctx).json(node);
        verify(ctx).status(201);
    }

    @Test
    public void dropAvatarStatus3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("login")).thenReturn("login");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(3);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("update users set avatar = NULL where login = ? and status != 3"))
                .thenReturn(statement2);

        String resJson = "{\"result\" : 1,\"message\": \"avatar dropped\"}";

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson)).thenReturn(node);
        AdminController.dropAvatar.handle(ctx);

        verify(statement2).setString(1, "login");
        verify(statement2).executeUpdate();
        verify(ctx).json(node);
        verify(ctx).status(201);
    }

    @Test
    public void dropUserHostsStatus3() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("login")).thenReturn("login");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("select status from users where login = ?;"))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next()).thenReturn(true);
        when(rs.getInt("status")).thenReturn(3);

        PreparedStatement statement2 = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("delete from hosts_servers where login = ?"))
                .thenReturn(statement2);

        String resJson = "{\"result\" : 1,\"message\": \"hosts dropped\"}";

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson)).thenReturn(node);
        AdminController.dropUserHosts.handle(ctx);

        verify(statement2).setString(1, "login");
        verify(statement2).executeUpdate();
        verify(ctx).json(node);
        verify(ctx).status(201);
    }
}