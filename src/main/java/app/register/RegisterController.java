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
            result = "{\"result\" : 1,\"message\": \"User inserted\"}";
            CustomEmail verificationEmail = new CustomEmail();
            verificationEmail.sendVerificationEmail(email,login,token,"en");
        }
        else {
            result = "{\"result\" : 0,\"message\": \"Such email or login already exist\"}";
        }
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);
    };

    public static Handler registerWithLoc = ctx -> {
        String login = ctx.queryParam("login");
        String email = ctx.queryParam("email");
        String pwd = ctx.queryParam("pwd");
        String lang = ctx.queryParam("lang");
        String token = UUID.randomUUID().toString();
        String result;
        if (RegisterDao.insertRegister(email,login,pwd,token)){
            result = "{\"result\" : 1,\"message\": \"User inserted\"}";
            CustomEmail verificationEmail = new CustomEmail();
            verificationEmail.sendVerificationEmail(email,login,token,lang);
        }
        else {
            result = "{\"result\" : 0,\"message\": \"Such email or login already exist\"}";
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
        ctx.redirect("/#/verification");
    };
    /**
     * Drop password API
     * @see Handler
     */
    public static Handler dropPwd = ctx -> {
        String email = ctx.queryParam("email");
        String newPwd = PasswordGenerator.generatePassword(8);
        String result = RegisterDao.dropPass(email,newPwd);
        CustomEmail verificationEmail = new CustomEmail();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        if (jsonNode.get("result").asInt() == 2)
            verificationEmail.sendDropPwdEmail(email,newPwd,"en");
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);
    };

    public static Handler dropPwdWithLoc = ctx -> {
        String email = ctx.queryParam("email");
        String lang = ctx.queryParam("lang");
        String newPwd = PasswordGenerator.generatePassword(8);
        String result = RegisterDao.dropPass(email,newPwd);
        CustomEmail verificationEmail = new CustomEmail();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        if (jsonNode.get("result").asInt() == 2)
            verificationEmail.sendDropPwdEmail(email,newPwd,lang);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);
    };
}
