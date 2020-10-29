package app.login;

import io.javalin.http.Handler;
import java.util.Map;

import app.user.UserController;
import app.util.Path;
import app.util.ViewUtil;

import static app.util.RequestUtil.*;

public class LoginController {


    public static Handler isLogIned = ctx -> {
        if( ctx.cookie("username") == null ){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"user is not logined\"}"));
            ctx.status(200);
        } else {
            ctx.json(stringToJson("{\"result\" : 1,\"message\": \"user is logined\"}"));
            ctx.status(200);
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
        ctx.sessionAttribute("currentUser", null);
        ctx.sessionAttribute("loggedOut", "true");
        ctx.redirect(Path.Web.LOGIN);
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

}
