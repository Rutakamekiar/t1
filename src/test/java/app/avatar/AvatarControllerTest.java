package app.avatar;

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

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.powermock.api.mockito.PowerMockito.doThrow;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({AvatarDao.class, RequestUtil.class})
@PowerMockIgnore({"javax.management.*", "javax.script.*", "com.sun.org.apache.xerces.*", "javax.xml.*",
        "org.xml.*", "org.w3c.*"})
public class AvatarControllerTest {

    @Test
    public void setAvatar_userNull() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.body()).thenReturn("body");
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AvatarController.setAvatar.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setAvatar_userNonNull() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.body()).thenReturn("body");
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(AvatarDao.class);
        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"avatar updated\"}"))
                .thenReturn(node);
        AvatarController.setAvatar.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void setAvatar_throwEx() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.body()).thenReturn("body");
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(AvatarDao.class);
        mockStatic(RequestUtil.class);
        doThrow(new ExceptionInInitializerError())
                .when(RequestUtil.class);
        RequestUtil.stringToJson(anyString());

        AvatarController.setAvatar.handle(ctx);

        verify(ctx).status(401);
    }

    @Test
    public void getAvatar_userNull() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn(null);

        mockStatic(AvatarDao.class);
        mockStatic(RequestUtil.class);
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"))
                .thenReturn(node);
        AvatarController.getAvatar.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

    @Test
    public void getAvatar_userNonNull() throws Exception {
        Context ctx = PowerMockito.mock(Context.class);
        Mockito.when(ctx.cookie("username")).thenReturn("username");

        mockStatic(AvatarDao.class);
        mockStatic(RequestUtil.class);
        when(AvatarDao.getAvatar("username"))
                .thenReturn("username");
        JsonNode node = new IntNode(3);
        when(RequestUtil.stringToJson("{\"result\" : 1,\"message\": \"username\"}"))
                .thenReturn(node);

        AvatarController.getAvatar.handle(ctx);

        verify(ctx).json(node);
        verify(ctx).status(200);
    }

}