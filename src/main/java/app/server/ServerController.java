package app.server;

import app.agentmsg.Agentmsg;
import io.javalin.http.Handler;

import java.sql.SQLException;

import static app.util.RequestUtil.getQueryUsername;


public class ServerController {

    public static Handler getUserServers = ctx -> {
        String username = ctx.cookieStore("username");


        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

    public static Handler addServerToUser = ctx -> {
        String username = ctx.cookie("username");
        String host = ctx.queryParam("host");

        try {
            ServerDao.addServerToUser( username , host);
        }
        catch (NoSuchFieldException e)
        {
            ctx.json("{\"result\" : 0,\"message\": \"Host not found\"}");
            ctx.status(404);
        }
        catch (SQLException e){
            ctx.json("{\"result\" : 0,\"message\": \"SQLException\"}");
            ctx.status(404);
            throw e;
        }

        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

    public static Handler deleteUserFromServer = ctx -> {
        String username = ctx.cookie("username");
        String host = ctx.queryParam("host");

        try {
            ServerDao.deleteServerFromUser( username , host);
        }
        catch ( SQLException e){
            ctx.json("{\"result\" : 0,\"message\": \"SQLException\"}");
            ctx.status(404);
            throw e;
        }
        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(201);
    };

}
