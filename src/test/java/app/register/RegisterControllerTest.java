package app.register;

import app.database.DBconnectionContainer;
import app.util.PasswordGenerator;
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
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({PasswordGenerator.class, RegisterDao.class, RequestUtil.class, DBconnectionContainer.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class RegisterControllerTest {

    @Test
    public void dropPwd() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.queryParam("email")).thenReturn("email");

        mockStatic(RequestUtil.class);
        mockStatic(PasswordGenerator.class);
        mockStatic(RegisterDao.class);
        when(PasswordGenerator.generatePassword(anyInt())).thenReturn("hui");
        when(RegisterDao.dropPass("email", "hui"))
                .thenReturn("{\"result\": 3}");
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        RegisterController.dropPwd.handle(ctx);

        verify(ctx).json(any(JsonNode.class));
        verify(ctx).status(201);
    }

    @Test
    public void dropPwdWithLoc() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.queryParam("email")).thenReturn("email");

        mockStatic(RequestUtil.class);
        mockStatic(PasswordGenerator.class);
        mockStatic(RegisterDao.class);
        when(PasswordGenerator.generatePassword(anyInt())).thenReturn("hui");
        when(RegisterDao.dropPass("email", "hui"))
                .thenReturn("{\"result\": 3}");
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        RegisterController.dropPwdWithLoc.handle(ctx);

        verify(ctx).json(any(JsonNode.class));
        verify(ctx).status(201);
    }

    @Test
    public void verifyEmail() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.queryParam("token")).thenReturn("token");

        mockStatic(RegisterDao.class);

        RegisterController.verifyEmail.handle(ctx);

        verify(ctx).result("user verified");
        verify(ctx).status(201);
    }
}