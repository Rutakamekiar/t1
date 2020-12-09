package app.activeCheck;

import app.activecheck.ActiveCheckController;
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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.doThrow;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({ActiveCheckDao.class, URLValidator.class, RequestUtil.class, DBconnectionContainer.class})
@PowerMockIgnore({"com.sun.org.apache.xerces.*", "javax.xml.*", "org.xml.*", "org.w3c.*"})
public class ActiveCheckControllerTest {

    @Test
    public void addServerToUserInvalidUrlTest() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        Mockito.when(ctx.queryParam("url")).thenReturn("https://www.google.com/");

        mockStatic(URLValidator.class);
        mockStatic(RequestUtil.class);

        when(URLValidator.isValidURL(anyString())).thenReturn(false);
        JsonNode node = new IntNode(1);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"Invalid url\"}")).thenReturn(node);
        ActiveCheckController.addServerToUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void addServerToUserCheckAddTest() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        Mockito.when(ctx.queryParam("url")).thenReturn("https://www.google.com/");

        mockStatic(URLValidator.class);
        mockStatic(RequestUtil.class);
        mockStatic(ActiveCheckDao.class);

        when(URLValidator.isValidURL(anyString())).thenReturn(true);
        when(ActiveCheckDao.checkAdd("username")).thenReturn(true);
        JsonNode node = new IntNode(1);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"Url added\"}")).thenReturn(node);
        ActiveCheckController.addServerToUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }

    @Test
    public void addServerToUserCheckNoAddTest() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        Mockito.when(ctx.queryParam("url")).thenReturn("https://www.google.com/");

        mockStatic(URLValidator.class);
        mockStatic(RequestUtil.class);
        mockStatic(ActiveCheckDao.class);

        when(URLValidator.isValidURL(anyString())).thenReturn(true);
        when(ActiveCheckDao.checkAdd("username")).thenReturn(false);
        JsonNode node = new IntNode(1);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"Update to premium to add more urls to check\"}"))
                .thenReturn(node);
        ActiveCheckController.addServerToUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }

    @Test
    public void addServerToUserThrowExceptions() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        Mockito.when(ctx.queryParam("url")).thenReturn("https://www.google.com/");

        mockStatic(URLValidator.class);
        mockStatic(RequestUtil.class);
        mockStatic(ActiveCheckDao.class);

        when(URLValidator.isValidURL(anyString())).thenReturn(true);
        doThrow(new RuntimeException("")).when(ActiveCheckDao.class);
        ActiveCheckDao.addLinkToUser(anyString(), anyString());

        when(ActiveCheckDao.checkAdd("username")).thenReturn(true);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"))
                .thenReturn(node);
        ActiveCheckController.addServerToUser.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }

    @Test
    public void deleteUrlSuccess() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement("delete from user_link where login = ? and url = ?"))
                .thenReturn(statement);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"Url deleted\"}"))
                .thenReturn(node);
        ActiveCheckController.deleteUrl.handle(ctx);

        verify(statement).executeUpdate();
        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }

    @Test
    public void deleteUrlExceptionTest() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");
        Mockito.when(ctx.queryParam("url")).thenReturn("https://www.google.com/");

        mockStatic(RequestUtil.class);
        mockStatic(ActiveCheckDao.class);
        doThrow(new RuntimeException()).when(ActiveCheckDao.class);
        ActiveCheckDao.deleteUrl(anyString(), anyString());

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"))
                .thenReturn(node);
        ActiveCheckController.deleteUrl.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }

    @Test
    public void getChecksSuccess() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement(any()))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next())
                .thenReturn(true)
                .thenReturn(true)
                .thenReturn(false);
        when(rs.getString(1)).thenReturn("1");
        when(rs.getString(2)).thenReturn("2");
        when(rs.getString(3)).thenReturn("3");

        String resJson = "{ \"uptime\":[ " + "{ \"url\" :\"1\"," +
                " \"all_checks\" :\"2\"," +
                " \"up\" :\"3\"" +
                "}" + ",{ \"url\" :\"1\"," +
                " \"all_checks\" :\"2\"," +
                " \"up\" :\"3\"" +
                "}" + "] }";
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson))
                .thenReturn(node);
        ActiveCheckController.getChecks.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx).status(200);
    }

    @Test
    public void getChecksExceptionTest() throws Exception {
        Context ctx = mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(DBconnectionContainer.class);
        mockStatic(RequestUtil.class);
        Connection connection = mock(Connection.class);
        PowerMockito.when(DBconnectionContainer.getDBconnection()).thenReturn(connection);
        PreparedStatement statement = mock(PreparedStatement.class);
        Mockito.when(connection.prepareStatement(any()))
                .thenReturn(statement);
        ResultSet rs = mock(ResultSet.class);
        when(statement.executeQuery()).thenReturn(rs);
        when(rs.next())
                .thenReturn(false);

        String resJson = "{\"result\" : 0,\"message\": \"There are no servers\"}";
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson(resJson))
                .thenReturn(node);
        ActiveCheckController.getChecks.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).header("Access-Control-Allow-Origin", "*");
        verify(ctx, times(2)).status(200);
    }
}