package app;

import app.admin.AdminController;
import app.agentmsg.AgentmsgController;
import app.avatar.AvatarController;
import app.index.IndexController;
import app.login.LoginController;
import app.login.SignIn;
import app.register.RegisterController;
import app.server.ServerController;
import app.util.Filters;
import app.util.Path;
import io.javalin.Javalin;
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.util.ssl.SslContextFactory;

import static io.javalin.apibuilder.ApiBuilder.*;


/**
 * Main class
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class Main {

    public static void main(String[] args) {

        Javalin app = Javalin.create(config -> {
            config.server(() -> {
                Server server = new Server();
                ServerConnector sslConnector = new ServerConnector(server, getSslContextFactory());
                sslConnector.setPort(443);
                ServerConnector connector = new ServerConnector(server);
                connector.setPort(80);
                server.setConnectors(new Connector[]{sslConnector, connector});
                return server;
            });
            config.addStaticFiles("/front/build/web");
            //config.enforceSsl = true;
        }).start(); // valid endpoint for both connectors

        app.routes(() -> {
            before(Filters.handleLocaleChange);
            before(LoginController.ensureLoginBeforeViewingBooks);
            get(Path.Web.INDEX, IndexController.serveIndexPage);
            get(Path.Web.LOGIN, LoginController.serveLoginPage);
            get(Path.Web.GETAGENTMSG, AgentmsgController.getMessage);
            get(Path.Web.VERIFICATE,RegisterController.verifyEmail);
            get(Path.Web.GETUSERSERVERS, ServerController.getUserServers);
            get(Path.Web.ISLOGIN, LoginController.isLogIned);
            get(Path.Web.ROBOTSTXT, IndexController.getRobotsTXT);
            put(Path.Web.ADDSERVERTOUSER, ServerController.addServerToUser);
            delete(Path.Web.DELETESERVERFROMUSER, ServerController.deleteUserFromServer);
            post(Path.Web.LOGIN, LoginController.handleLoginPost);
            post(Path.Web.LOGOUT, LoginController.handleLogoutPost);
            post(Path.Web.SIGNIN, SignIn.logIn);
            post(Path.Web.AGENTMSG, AgentmsgController.processMessage);
            post(Path.Web.REGISTER, RegisterController.register);
            post(Path.Web.REGISTER_WITH_LOC, RegisterController.registerWithLoc);
            post(Path.Web.DROPPWD, RegisterController.dropPwd);
            post(Path.Web.DROPPWD_WITH_LOC, RegisterController.dropPwdWithLoc);
            post(Path.Web.SETAVATAR, AvatarController.setAvatar);
            get(Path.Web.GETAVATAR, AvatarController.getAvatar);
            get(Path.Web.GETALLUSERSADMIN, AdminController.getAllUsers);
            post(Path.Web.ADMINSETFREE, AdminController.setFreeUser);
            post(Path.Web.ADMINSETPREMIUM, AdminController.setPremiumUser);
            post(Path.Web.ADMINDROPAVATAR,AdminController.dropAvatar);
            post(Path.Web.DROPUSERHOSTS,AdminController.dropUserHosts);
            post(Path.Web.GENERATEKEYS,LoginController.generateKeys);
            post(Path.Web.GETPREMIUM,LoginController.getPremium);
        });

        app.error(404,  ctx -> {
            ctx.html("Generic 404 message");
        });
        app.error(500, ctx -> {
            ctx.result("Generic 500 message");
        });
        app.error(501, ctx -> {
            ctx.result("Generic 500 message");
        });
        app.error(502, ctx -> {
            ctx.result("Generic 500 message");
        });
        app.error(503, ctx -> {
            ctx.result("Generic 500 message");
        });
        app.error(504, ctx -> {
            ctx.result("Generic 500 message");
        });

    }

    private static SslContextFactory getSslContextFactory() {
        //noinspection deprecation
        SslContextFactory sslContextFactory = new SslContextFactory();
        sslContextFactory.setKeyStorePath(Main.class.getResource("/sertificates/keystore_tss").toExternalForm());
        sslContextFactory.setKeyStorePassword("tss123");
        return sslContextFactory;
    }

}
