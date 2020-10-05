package app.register;

import app.agentmsg.AgentmsgDao;
import app.email.CustomEmail;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;

import java.util.UUID;

public class RegisterController {
    public static Handler register = ctx -> {
        String login = ctx.queryParam("login");
        String email = ctx.queryParam("email");
        String pwd = ctx.queryParam("pwd");
        String token = UUID.randomUUID().toString();
        String result;
        if (RegisterDao.insertRegister(email,login,pwd,token)){
            result = "{\"result\" : 1,\"message\": \"User inserted1\"}";
            CustomEmail verificationEmail = new CustomEmail();
            verificationEmail.sendVerificationEmailBody(email,login,token);
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
    public static Handler verifyEmail = ctx -> {
        String token = ctx.queryParam("token");
        RegisterDao.verifyEmail(token);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.status(201);
        ctx.result("user verified");
    };
}
