package app;

import app.activecheck.ActiveCheck;
import app.activecheck.ActiveCheckController;
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
import app.util.SessionUtils;
import io.javalin.Javalin;
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.util.ssl.SslContextFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Timer;
import java.util.TimerTask;

import static io.javalin.apibuilder.ApiBuilder.*;


/**
 * Main class
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class Main {

    public static void main(String[] args) {

        Timer timer = new Timer();

        timer.schedule( new TimerTask() {
            public void run() {
                try {
                    ActiveCheck.checkAllUrl();
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }, 0, 60*1000*10);

        Runnable myRunnable = new Runnable() {

            public void run() {

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
                    config.sessionHandler(SessionUtils.customSessionHandlerSupplier());
                }).start(); // valid endpoint for both connectors

                app.routes(() -> {
                    before(Filters.handleLocaleChange);
                    before(LoginController.ensureLoginBeforeViewingBooks);
                    get(Path.WebUnloginnedAccess.INDEX, IndexController.serveIndexPage);
                    get(Path.WebLogInnedAccess.GETAGENTMSG, AgentmsgController.getMessage);
                    get(Path.WebUnloginnedAccess.VERIFICATE,RegisterController.verifyEmail);
                    get(Path.WebLogInnedAccess.GETUSERSERVERS, ServerController.getUserServers);
                    get(Path.WebUnloginnedAccess.ISLOGIN, LoginController.isLogIned);
                    get(Path.WebUnloginnedAccess.ROBOTSTXT, IndexController.getRobotsTXT);
                    put(Path.WebLogInnedAccess.ADDSERVERTOUSER, ServerController.addServerToUser);
                    delete(Path.WebLogInnedAccess.DELETESERVERFROMUSER, ServerController.deleteUserFromServer);
                    post(Path.WebUnloginnedAccess.LOGOUT, LoginController.handleLogoutPost);
                    post(Path.WebUnloginnedAccess.SIGNIN, SignIn.signIn);
                    post(Path.WebUnloginnedAccess.AGENTMSG, AgentmsgController.processMessage);
                    post(Path.WebUnloginnedAccess.REGISTER, RegisterController.register);
                    post(Path.WebUnloginnedAccess.REGISTER_WITH_LOC, RegisterController.registerWithLoc);
                    post(Path.WebUnloginnedAccess.DROPPWD, RegisterController.dropPwd);
                    post(Path.WebUnloginnedAccess.DROPPWD_WITH_LOC, RegisterController.dropPwdWithLoc);
                    post(Path.WebLogInnedAccess.SETAVATAR, AvatarController.setAvatar);
                    get(Path.WebLogInnedAccess.GETAVATAR, AvatarController.getAvatar);
                    get(Path.WebLogInnedAccess.GETALLUSERSADMIN, AdminController.getAllUsersAdmin);
                    post(Path.WebLogInnedAccess.ADMINSETFREE, AdminController.setFreeUser);
                    post(Path.WebLogInnedAccess.ADMINSETPREMIUM, AdminController.setPremiumUser);
                    post(Path.WebLogInnedAccess.ADMINDROPAVATAR,AdminController.dropAvatar);
                    post(Path.WebLogInnedAccess.DROPUSERHOSTS,AdminController.dropUserHosts);
                    post(Path.WebLogInnedAccess.GENERATEKEYS,LoginController.generateKeys);
                    post(Path.WebLogInnedAccess.GETPREMIUM,LoginController.getPremium);
                    post(Path.WebLogInnedAccess.ADD_URL, ActiveCheckController.addServerToUser);
                    post(Path.WebLogInnedAccess.DELETE_URL,ActiveCheckController.deleteUrl);
                    get(Path.WebLogInnedAccess.GET_UPTIME,ActiveCheckController.getChecks);
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

        };
        Thread a = new Thread(myRunnable, "Thread one");
        a.start();



    }

    private static SslContextFactory getSslContextFactory() {
        SslContextFactory sslContextFactory = new SslContextFactory();
        sslContextFactory.setKeyStorePath(Main.class.getResource("/sertificates/keystore_tss").toExternalForm());
        sslContextFactory.setKeyStorePassword("tss123");
        return sslContextFactory;
    }

}
