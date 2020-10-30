package app.login;

import app.user.User;
import app.util.Path;
import io.javalin.http.Handler;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

import static app.util.RequestUtil.*;

public class SignIn {

    public static boolean authenticate(String username, String password) throws NoSuchFieldException, SQLException {
        if (username == null || password == null) {
            return false;
        }
        Customer customer = Customer.getCustomerFromDB(username);
        if ( password.equals(customer.getPassword())) {
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
                ctx.header("Access-Control-Allow-Origin", "*");
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"welcome\"}"));
                ctx.status(200);
            } else {
                ctx.result("incorrect value").status(404);
                ctx.json(stringToJson("{\"result\" : 0,\"message\": \"incorrect password\"}"));
                ctx.status(200);
            }
        } catch (NoSuchFieldException ex) {
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"missing user\"}"));
            ctx.status(200);
        }
        catch (ExceptionInInitializerError e){
            ctx.status(401);
        }
        catch (SQLException e){
            ctx.json(stringToJson("{\"result\" : 0,\"message\": \"something went wrong\"}"));
            ctx.status(200);
        }

    };

}
