package app.register;

import app.agentmsg.AgentmsgDao;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;

public class RegisterController {
    public static Handler register = ctx -> {
        String login = ctx.queryParam("login");
        String email = ctx.queryParam("email");
        String pwd = ctx.queryParam("pwd");
        String result;
        if (RegisterDao.insertRegister(email,login,pwd)){
            result = "{\"result\" : 1,\"message\": \"User inserted1\"}";
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
}
