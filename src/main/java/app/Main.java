package app;

import app.agentmsg.AgentmsgController;
import app.index.IndexController;
import app.login.LoginController;
import app.login.SignIn;
import app.register.RegisterController;
import app.server.ServerController;
import app.user.UserDao;
import app.util.Filters;
import app.util.HerokuUtil;
import app.util.Path;
import app.util.ViewUtil;
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
            put(Path.Web.ADDSERVERTOUSER, ServerController.addServerToUser);
            delete(Path.Web.DELETESERVERFROMUSER, ServerController.deleteUserFromServer);
            post(Path.Web.LOGIN, LoginController.handleLoginPost);
            post(Path.Web.LOGOUT, LoginController.handleLogoutPost);
            post(Path.Web.SIGNIN, SignIn.logIn);
            post(Path.Web.AGENTMSG, AgentmsgController.processMessage);
            post(Path.Web.REGISTER, RegisterController.register);
            post(Path.Web.DROPPWD, RegisterController.dropPwd);
        });

        app.error(404, ViewUtil.notFound);


    }

    private static SslContextFactory getSslContextFactory() {
        SslContextFactory sslContextFactory = new SslContextFactory();
        sslContextFactory.setKeyStorePath(Main.class.getResource("/sertificates/keystore_tss").toExternalForm());
        sslContextFactory.setKeyStorePassword("tss123");
        return sslContextFactory;
    }

}
