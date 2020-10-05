package app;

import app.agentmsg.AgentmsgController;
import app.book.BookController;
import app.book.BookDao;
import app.index.IndexController;
import app.login.LoginController;
import app.login.SignIn;
import app.register.RegisterController;
import app.user.UserDao;
import app.util.Filters;
import app.util.HerokuUtil;
import app.util.Path;
import app.util.ViewUtil;
import io.javalin.Javalin;

import static io.javalin.apibuilder.ApiBuilder.before;
import static io.javalin.apibuilder.ApiBuilder.get;
import static io.javalin.apibuilder.ApiBuilder.post;


public class Main {

    // Declare dependencies
    public static BookDao bookDao;
    public static UserDao userDao;

    public static void main(String[] args) {

        // Instantiate your dependencies
        bookDao = new BookDao();
        userDao = new UserDao();


        Javalin app = Javalin.create(
            config -> {
                config.addStaticFiles("/front/build/web");
            }
        ).start(HerokuUtil.getHerokuAssignedPort());

        app.routes(() -> {
            before(Filters.handleLocaleChange);
            before(LoginController.ensureLoginBeforeViewingBooks);
            get(Path.Web.INDEX, IndexController.serveIndexPage);
            get(Path.Web.BOOKS, BookController.fetchAllBooks);
            get(Path.Web.ONE_BOOK, BookController.fetchOneBook);
            get(Path.Web.LOGIN, LoginController.serveLoginPage);
            get(Path.Web.GETAGENTMSG, AgentmsgController.getMessage);
            get(Path.Web.VERIFICATE,RegisterController.verifyEmail);
            post(Path.Web.LOGIN, LoginController.handleLoginPost);
            post(Path.Web.LOGOUT, LoginController.handleLogoutPost);
            post(Path.Web.SIGNIN, SignIn.logIn);
            post(Path.Web.AGENTMSG, AgentmsgController.processMessage);
            post(Path.Web.REGISTER, RegisterController.register);


        });

        app.error(404, ViewUtil.notFound);
    }

}
