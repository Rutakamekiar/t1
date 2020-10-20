package app.register;

import app.agentmsg.AgentmsgDao;
import app.email.CustomEmail;
import app.util.PasswordGenerator;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;

import java.util.UUID;

/**
 * Class controller to work with registration
 * @author Zhuravlev Yuriu
 * @version 1.0
 */
public class RegisterController {
    /**
     * Registration API
     * @see Handler
     */
    public static Handler register = ctx -> {
        String login = ctx.queryParam("login");
        String email = ctx.queryParam("email");
        String pwd = ctx.queryParam("pwd");
        String token = UUID.randomUUID().toString();
        String result;
        if (RegisterDao.insertRegister(email,login,pwd,token)){
            result = "{\"result\" : 1,\"message\": \"User inserted1\"}";
            CustomEmail verificationEmail = new CustomEmail();
            verificationEmail.sendVerificationEmail(email,login,token);
        }
        else {
            result = "{\"result\" : 0,\"message\": \"Such email or login already exist1\"}";
        }
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);

    };
    /**
     * Verification of email API
     * @see Handler
     */
    public static Handler verifyEmail = ctx -> {
        String token = ctx.queryParam("token");
        RegisterDao.verifyEmail(token);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.status(201);
        ctx.result("user verified");
    };
    /**
     * Drop password API
     * @see Handler
     */
    public static Handler dropPwd = ctx -> {
        String email = ctx.queryParam("email");
        String newPwd = PasswordGenerator.generatePassword(8);
        String result = RegisterDao.dropPass(email,newPwd);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);

    };
}