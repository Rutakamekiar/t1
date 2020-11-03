package app.server;

import app.agentmsg.Agentmsg;
import io.javalin.http.Handler;
import org.postgresql.util.PSQLException;

import java.sql.SQLException;

import static app.util.RequestUtil.getQueryUsername;
import static app.util.RequestUtil.stringToJson;


public class ServerController {

    public static Handler getUserServers = ctx -> {
        String username = ctx.cookie("username");

        String result = "{\"result\" : 0,\"message\": \"Something went wrong\"}";

        try {
            result = ServerDao.getUserServers( username );
        }
        catch (NoSuchFieldException e)
        {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"There are no servers\"}"));
            ctx.status(200);
        }
        catch (SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"SQLException\"}"));
            ctx.status(200);
            throw e;
        }
        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.json(stringToJson(result));
        ctx.status(200);
    };

    public static Handler addServerToUser = ctx -> {
        String username = ctx.cookie("username");
        String publicKey = ctx.queryParam("public_key");

        try {
            ServerDao.addServerToUser( username , publicKey);
        }
        catch (NoSuchFieldException e)
        {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Host not found\"}"));
            ctx.status(200);
        }
        catch (PSQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Server already added\"}"));
            ctx.status(200);
        }

        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

    public static Handler deleteUserFromServer = ctx -> {
        String username = ctx.cookie("username");
        String publicKey = ctx.queryParam("public_key");

        try {
            ServerDao.deleteServerFromUser( username , publicKey);
        }
        catch ( SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"SQLException\"}"));
            ctx.status(200);
            throw e;
        }
        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

}
