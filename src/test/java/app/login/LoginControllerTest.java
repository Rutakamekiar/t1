package app.login;

import app.util.RequestUtil;
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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.doThrow;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({Customer.class, RequestUtil.class, SignIn.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class LoginControllerTest {

    @Test
    public void isLoggedTrue() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username").thenReturn("username").thenReturn("username");

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        when(Customer.checkUserStatusFromDB("username"))
                .thenReturn(1);
        when(Customer.intStatusToString(1))
                .thenReturn("free");

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"user is logined\",\"user\": \"username\"," +
                " \"user-status\": \"free\"}"))
                .thenReturn(node);
        LoginController.isLogIned.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void isLoggedFalse() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        LoginController.isLogIned.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void handleLoginPost() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(Customer.class);
        mockStatic(SignIn.class);
        mockStatic(RequestUtil.class);
        Customer customer = new Customer("", "", "status");
        when(Customer.getCustomerFromDB(any()))
                .thenReturn(customer);
        when(RequestUtil.getQueryPassword(any())).thenReturn("password");
        when(SignIn.authenticate(customer, "password"))
                .thenReturn(true);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"welcome\", \"user-status\" : \"status\"}"))
                .thenReturn(node);
        LoginController.handleLoginPost.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void handleLoginPost_notAuth() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(Customer.class);
        mockStatic(SignIn.class);
        mockStatic(RequestUtil.class);
        Customer customer = new Customer("", "", "status");
        when(Customer.getCustomerFromDB(any()))
                .thenReturn(customer);
        when(RequestUtil.getQueryPassword(any())).thenReturn("password");
        when(SignIn.authenticate(customer, "password"))
                .thenReturn(false);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"authenticationFailed\"}"))
                .thenReturn(node);
        LoginController.handleLoginPost.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void handleLoginPost_401() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(Customer.class);
        doThrow(new ExceptionInInitializerError()).when(Customer.class);
        Customer.getCustomerFromDB(any());

        LoginController.handleLoginPost.handle(ctx);

        verify(ctx).status(401);
    }

    @Test
    public void handleLogoutPost() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        mockStatic(RequestUtil.class);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"user is logedout\"}"))
                .thenReturn(node);
        LoginController.handleLogoutPost.handle(ctx);

        verify(ctx).removeCookie("username");
        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void ensureLoginBeforeViewingBooks() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        when(ctx.sessionAttribute("currentUser")).thenReturn(null);
        when(ctx.path()).thenReturn("/books");

        LoginController.ensureLoginBeforeViewingBooks.handle(ctx);

        verify(ctx).sessionAttribute(any(), any());
    }

    @Test
    public void ensureLoginBeforeViewingBooks_wrongPath() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        when(ctx.sessionAttribute("currentUser")).thenReturn(null);
        when(ctx.path()).thenReturn("/bo");

        LoginController.ensureLoginBeforeViewingBooks.handle(ctx);

        verify(ctx, never()).sessionAttribute(any());
    }

    @Test
    public void generateKeys() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        String adminTeam = "adminTeam1";
        when(ctx.cookie("username")).thenReturn(adminTeam);

        mockStatic(Customer.class);

        LoginController.generateKeys.handle(ctx);

        verify(ctx).status(200);
    }

    @Test
    public void generateKeys_401() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        String adminTeam = "adminTeam";
        when(ctx.cookie("username")).thenReturn(adminTeam);

        mockStatic(Customer.class);

        LoginController.generateKeys.handle(ctx);

        verify(ctx).status(401);
    }

    @Test
    public void getPremium_status2() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("code")).thenReturn("code");
        mockStatic(RequestUtil.class);
        mockStatic(Customer.class);
        when(Customer.checkUserStatusFromDB("username"))
                .thenReturn(2);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user already have premium grants\"}"))
                .thenReturn(node);
        LoginController.getPremium.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getPremium_noUser() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        when(ctx.cookie("username")).thenReturn(null);
        when(ctx.queryParam("code")).thenReturn("code");
        mockStatic(RequestUtil.class);
        mockStatic(Customer.class);
        when(Customer.checkUserStatusFromDB("username"))
                .thenReturn(2);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        LoginController.getPremium.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getPremium_invalidUserCode() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("code")).thenReturn("code");
        mockStatic(RequestUtil.class);
        mockStatic(Customer.class);
        when(Customer.checkUserStatusFromDB("username"))
                .thenReturn(1);
        when(Customer.validateUserCode("code"))
                .thenReturn(false);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"incorrect code\"}"))
                .thenReturn(node);
        LoginController.getPremium.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getPremium_provide() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        when(ctx.cookie("username")).thenReturn("username");
        when(ctx.queryParam("code")).thenReturn("code");
        mockStatic(RequestUtil.class);
        mockStatic(Customer.class);
        when(Customer.checkUserStatusFromDB("username"))
                .thenReturn(1);
        when(Customer.validateUserCode("code"))
                .thenReturn(true);

        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"premium provided\"}"))
                .thenReturn(node);
        LoginController.getPremium.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }
}