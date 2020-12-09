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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.doThrow;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({Customer.class, RequestUtil.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class SignInTest {

    @Test
    public void login() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.formParam("username")).thenReturn("username");
        Mockito.when(ctx.formParam("password")).thenReturn("password");

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        when(Customer.getCustomerFromDB("username"))
                .thenReturn(new Customer("username", "password", "premium"));
        when(RequestUtil.getQueryUsername(ctx)).thenReturn("username");
        when(RequestUtil.getQueryPassword(ctx)).thenReturn("password");
        JsonNode node = new  IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"welcome\", \"user-status\" : \"premium\"}"))
                .thenReturn(node);
        SignIn.logIn.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void loginFailed() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        when(Customer.getCustomerFromDB("username"))
                .thenReturn(new Customer("username", "pass", "premium"));
        when(RequestUtil.getQueryUsername(ctx)).thenReturn("username");
        when(RequestUtil.getQueryPassword(ctx)).thenReturn("password");
        when(ctx.result(anyString())).thenReturn(ctx);
        JsonNode node = new  IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"incorrect password\"}"))
                .thenReturn(node);
        SignIn.logIn.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).result("incorrect value");
        verify(ctx).status(200);
    }

    @Test
    public void login401() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        doThrow(new ExceptionInInitializerError()).when(Customer.class);
        Customer.getCustomerFromDB(any());

        SignIn.logIn.handle(ctx);

        verify(ctx).status(401);
    }

    @Test
    public void signIn() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.formParam("username")).thenReturn("username");
        Mockito.when(ctx.formParam("password")).thenReturn("password");

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        when(Customer.getCustomerFromDB("username"))
                .thenReturn(new Customer("username", "password", "premium"));
        when(RequestUtil.getQueryUsername(ctx)).thenReturn("username");
        when(RequestUtil.getQueryPassword(ctx)).thenReturn("password");
        JsonNode node = new  IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"welcome\", \"user-status\" : \"premium\"}"))
                .thenReturn(node);
        SignIn.signIn.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void signInFailed() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        when(Customer.getCustomerFromDB("username"))
                .thenReturn(new Customer("username", "pass", "premium"));
        when(RequestUtil.getQueryUsername(ctx)).thenReturn("username");
        when(RequestUtil.getQueryPassword(ctx)).thenReturn("password");
        when(ctx.result(anyString())).thenReturn(ctx);
        JsonNode node = new  IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"incorrect password\"}"))
                .thenReturn(node);
        SignIn.signIn.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).result("incorrect value");
        verify(ctx).status(200);
    }

    @Test
    public void signIn401() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);

        mockStatic(Customer.class);
        mockStatic(RequestUtil.class);
        doThrow(new ExceptionInInitializerError()).when(Customer.class);
        Customer.getCustomerFromDB(any());

        SignIn.signIn.handle(ctx);

        verify(ctx).status(401);
    }
}