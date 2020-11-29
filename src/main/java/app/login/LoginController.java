package app.login;

import io.javalin.http.Handler;

import java.sql.SQLException;
import java.util.Map;

import app.user.UserController;
import app.util.Path;
import app.util.ViewUtil;

import static app.util.RequestUtil.*;

public class LoginController {


    public static Handler isLogIned = ctx -> {
        if (ctx.cookie("username") == null) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            try {
                int userStatus = Customer.checkUserStatusFromDB(ctx.cookie("username"));
                String stringUserStatus = Customer.intStatusToString(userStatus);
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"user is logined\",\"user\": \""
                        + ctx.cookie("username") + "\", \"user-status\": \"" + stringUserStatus + "\"}"));
                ctx.status(200);
            } catch (NoSuchFieldException ex) {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"missing user\"}"));
                ctx.status(200);
            } catch (SQLException e) {
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
                ctx.status(200);
            }
        }
    };

    public static Handler serveLoginPage = ctx -> {
        Map<String, Object> model = ViewUtil.baseModel(ctx);
        model.put("loggedOut", removeSessionAttrLoggedOut(ctx));
        model.put("loginRedirect", removeSessionAttrLoginRedirect(ctx));
        ctx.render(Path.Template.LOGIN, model);
    };

    public static Handler handleLoginPost = ctx -> {
        Map<String, Object> model = ViewUtil.baseModel(ctx);
        if (!UserController.authenticate(getQueryUsername(ctx), getQueryPassword(ctx))) {
            model.put("authenticationFailed", true);
            ctx.render(Path.Template.LOGIN, model);
        } else {
            ctx.sessionAttribute("currentUser", getQueryUsername(ctx));
            model.put("authenticationSucceeded", true);
            model.put("currentUser", getQueryUsername(ctx));
            if (getQueryLoginRedirect(ctx) != null) {
                ctx.redirect(getQueryLoginRedirect(ctx));
            }
            ctx.render(Path.Template.LOGIN, model);
        }
    };

    public static Handler handleLogoutPost = ctx -> {
        ctx.removeCookie("username");
        ctx.json(stringToJson("{\"result\" : 1,\"message\": \"user is logedout\"}"));
        ctx.status(200);
    };

    // The origin of the request (request.pathInfo()) is saved in the session so
    // the user can be redirected back after login
    public static Handler ensureLoginBeforeViewingBooks = ctx -> {
        if (!ctx.path().startsWith("/books")) {
            return;
        }
        if (ctx.sessionAttribute("currentUser") == null) {
            ctx.sessionAttribute("loginRedirect", ctx.path());
            ctx.redirect(Path.Web.LOGIN);
        }
    };

    public static Handler generateKeys = ctx -> {
        if (ctx.cookie("username") == "adminTeam1") {
            Customer.generateKeys();
            ctx.status(200);
        } else ctx.status(401);
    };

    public static Handler getPremium = ctx -> {
        String username = ctx.cookie("username");
        String ressult;
        String code = ctx.queryParam("code");
        System.out.println(code);
        if ( username == null) {
            ressult = "{\"result\" : 0,\"message\": \"user is not logined\"}";
        } else {
            int userStatus = Customer.checkUserStatusFromDB(username);
            if( userStatus == 2 || userStatus == 3){
                ressult = "{\"result\" : 0,\"message\": \"user already have premium grants\"}";
            } else {

                if( !Customer.validateUserCode(code) ){
                    ressult = "{\"result\" : 0,\"message\": \"incorrect code\"}";
                }
                else {
                    Customer.providePremium(username , code);
                    ressult = "{\"result\" : 1,\"message\": \"premium provided\"}";
                }
            }
        }
        ctx.json(stringToJson(ressult));
        ctx.status(200);
    };
}
