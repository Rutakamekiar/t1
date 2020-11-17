package app.avatar;

import io.javalin.http.Handler;

import java.sql.SQLException;

import static app.util.RequestUtil.stringToJson;

public class AvatarController {
    /**
     * Set avatar to user API
     */
    public static Handler setAvatar = ctx -> {
        try {
            String avatar = ctx.body();
            String user = ctx.cookie("username");
            if (user == null){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
                ctx.status(200);
            } else {
                AvatarDao.setAvatar(user, avatar);
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"avatar updated\"}"));
                ctx.status(200);
            }
        } catch (NoSuchFieldException ex) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"missing user\"}"));
            ctx.status(200);
        }
        catch (ExceptionInInitializerError e){
            ctx.status(401);
        }
        catch (SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
            ctx.status(200);
        }
        ctx.header("Access-Control-Allow-Origin", "*");
    };

    /**
     * Get avatar of user API
     */
    public static Handler getAvatar = ctx -> {
        try {
            String user = ctx.cookie("username");
            if (user == null){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
                ctx.status(200);
            } else {
                String avatar = AvatarDao.getAvatar(user);
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"" + avatar + "\"}"));
                ctx.status(200);
            }
        } catch (NoSuchFieldException ex) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"missing user\"}"));
            ctx.status(200);
        }
        catch (SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
            ctx.status(200);
        }
        ctx.header("Access-Control-Allow-Origin", "*");
    };
}
