package app.login;

import app.user.User;
import app.util.Path;
import io.javalin.http.Handler;
import org.mindrot.jbcrypt.BCrypt;

import static app.Main.userDao;
import static app.util.RequestUtil.getQueryPassword;
import static app.util.RequestUtil.getQueryUsername;

public class SignIn {

    public static boolean authenticate(String username, String password) {
        if (username == null || password == null) {
            return false;
        }
        Customer customer = new Customer("team1","12345");
        if (username.equals(customer.getLogin()) && password.equals(customer.getPassword())) {
            return true;
        }
        return false;
    }

    public static Handler logIn = ctx -> {
        String username;
        String password;
        try {
            username = getQueryUsername(ctx);
            password = getQueryPassword(ctx);
            if (authenticate(username, password)) {
                ctx.header("Access-Control-Allow-Origin", "*").status(200);
                //ctx.result("done").status(200);
            } else {
                ctx.result("incorrect value").status(404);
            }
        } catch (Exception ex) {
            ctx.result("error").status(404);
        }

    };

}