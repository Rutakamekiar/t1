package app.admin;

import app.agentmsg.Agentmsg;
import app.login.Customer;
import io.javalin.http.Handler;

import java.sql.SQLException;

import static app.util.RequestUtil.stringToJson;

public class AdminController {
    public static Handler getAllUsersAdmin = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                if (userStatus != 3) {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"));
                    ctx.status(200);
                } else {
                    ctx.json(stringToJson(AdminDao.getAllUsers()));
                    ctx.status(201);
                }
            }
            catch (NoSuchFieldException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"No such user\"}"));
                ctx.status(200);
            }
            catch (SQLException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };
    public static Handler setPremiumUser = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                if (userStatus != 3) {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"));
                    ctx.status(200);
                } else {
                    String login = ctx.queryParam("login");
                    AdminDao.changeStatus(login,2);
                    ctx.json(stringToJson("{\"result\" : 1,\"message\": \"premium status updated\"}"));
                    ctx.status(201);
                }
            }
            catch (SQLException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };
    public static Handler setFreeUser = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                if (userStatus != 3) {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"));
                    ctx.status(200);
                } else {
                    String login = ctx.queryParam("login");
                    AdminDao.changeStatus(login,1);
                    ctx.json(stringToJson("{\"result\" : 1,\"message\": \"free status updated\"}"));
                    ctx.status(201);
                }
            }
            catch (SQLException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };

    public static Handler dropAvatar = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                if (userStatus != 3) {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"));
                    ctx.status(200);
                } else {
                    String login = ctx.queryParam("login");
                    AdminDao.dropAvatar(login);
                    ctx.json(stringToJson("{\"result\" : 1,\"message\": \"avatar dropped\"}"));
                    ctx.status(201);
                }
            }
            catch (SQLException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };

    public static Handler dropUserHosts = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                if (userStatus != 3) {
                    ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not admin\"}"));
                    ctx.status(200);
                } else {
                    String login = ctx.queryParam("login");
                    AdminDao.dropUserHosts(login);
                    ctx.json(stringToJson("{\"result\" : 1,\"message\": \"hosts dropped\"}"));
                    ctx.status(201);
                }
            }
            catch (SQLException e){
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };
}
