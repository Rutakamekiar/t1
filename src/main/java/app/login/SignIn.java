package app.login;

import app.user.User;
import app.util.Path;
import io.javalin.http.Handler;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

import static app.util.RequestUtil.*;

public class SignIn {

    public static boolean authenticate(Customer customer, String password) {
        if (customer.getLogin() == null || password == null) {
            return false;
        }
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
            Customer customer = Customer.getCustomerFromDB(username);
            if (authenticate(customer, password)) {
                ctx.cookie("username", username);
                ctx.header("Access-Control-Allow-Origin", "*");
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"welcome\", \"user-status\" : \""+customer.getStatus()+"\"}"));
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

    public static Handler signIn = ctx -> {
        String username;
        String password;
        try {
            username = getQueryUsername(ctx);
            password = getQueryPassword(ctx);
            Customer customer = Customer.getCustomerFromDB(username);
            if (authenticate(customer, password)) {
                ctx.cookie("username", username);
                ctx.header("Access-Control-Allow-Origin", "*");
                ctx.json(stringToJson("{\"result\" : 1,\"message\": \"welcome\", \"user-status\" : \""+customer.getStatus()+"\"}"));
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
