package app.login;

import app.user.User;
import app.util.Path;
import io.javalin.http.Handler;
import org.mindrot.jbcrypt.BCrypt;

import static app.util.RequestUtil.*;

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
                ctx.cookie("username", username);
                ctx.header("Access-Control-Allow-Origin", "*").status(200);
            } else {
                ctx.result("incorrect value").status(404);
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"incorrect value\"}"));
                ctx.status(200);
            }
        } catch (Exception ex) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"Exception\"}"));
            ctx.status(200);
        }

    };

}
