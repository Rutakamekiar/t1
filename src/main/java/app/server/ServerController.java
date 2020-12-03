package app.server;

import app.agentmsg.Agentmsg;
import app.login.Customer;
import app.login.LoginController;
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
        catch (SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"SQLException\"}"));
            ctx.status(200);
            throw e;
        }
        catch ( Exception e){
            System.out.println(e.getStackTrace());
        }
        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.json(stringToJson(result));
        ctx.status(200);
    };

    public static Handler addServerToUser = ctx -> {
        String username = ctx.cookie("username");
        String publicKey = ctx.queryParam("public_key");
        String privateKey = ctx.queryParam("private_key");
        if( publicKey.length() == 0 ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"public_key can not be empty\"}"));
            ctx.status(200);
        }
        if( privateKey.length() == 0 ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"private_key can not be empty\"}"));
            ctx.status(200);
        }
        try {
            if(ServerDao.isAllowedToAddServer(ServerDao.getUserServers(username), Customer.checkUserStatusFromDB(username)))
            ServerDao.addServerToUser( username , publicKey, privateKey);
            else {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Update to premium to add more servers\"}"));
                ctx.status(200);
            }
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
        catch (Exception e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
            ctx.status(200);
        }

        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

    public static Handler deleteUserFromServer = ctx -> {
        String username = ctx.cookie("username");
        String publicKey = ctx.queryParam("public_key");

        try {
            ServerDao.deleteServerFromUser(username,publicKey);
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
