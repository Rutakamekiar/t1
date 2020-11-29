package app.activecheck;

import app.validate.URLValidator;
import io.javalin.http.Handler;
import org.postgresql.util.PSQLException;

import java.sql.SQLException;

import static app.util.RequestUtil.stringToJson;

public class ActiveCheckController {
    public static Handler addServerToUser = ctx -> {
        String username = ctx.cookie("username");
        String url = ctx.queryParam("url");

        if (!URLValidator.isValidURL(url)){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Invalid url\"}"));
            ctx.status(200);
        } else {
            try {
                if (ActiveCheckDao.checkAdd(username)) {
                    ActiveCheckDao.addLinkToUser(username, url);
                    ctx.json(stringToJson("{\"result\" : 1,\"message\": \"Url added\"}"));
                    ctx.status(200);
                }
                else {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Update to premium to add more urls to check\"}"));
                    ctx.status(200);
                }
            } catch (NoSuchFieldException e) {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Host not found\"}"));
                ctx.status(200);
            } catch (PSQLException e) {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Url already added\"}"));
                ctx.status(200);
            } catch (Exception e) {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }

            ctx.header("Access-Control-Allow-Origin", "*");
            ctx.status(200);
        }
    };

    public static Handler deleteUrl = ctx -> {
        String username = ctx.cookie("username");
        String url = ctx.queryParam("url");
        try {
            ActiveCheckDao.deleteUrl(username,url);
            ctx.json(stringToJson("{\"result\" : 1,\"message\": \"Url deleted\"}"));
            ctx.status(200);
        } catch (PSQLException e) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Url already added\"}"));
            ctx.status(200);
        } catch (Exception e) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
            ctx.status(200);
        }

        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.status(200);
    };

    public static Handler getChecks = ctx -> {
        String username = ctx.cookie("username");

        String result = "{\"result\" : 0,\"message\": \"Something went wrong\"}";

        try {
            result = ActiveCheckDao.getInfo(username);
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
        catch ( Exception e){
            System.out.println(e.getStackTrace());
        }
        ctx.header("Access-Control-Allow-Origin", "*");
        ctx.json(stringToJson(result));
        ctx.status(200);
    };
}
