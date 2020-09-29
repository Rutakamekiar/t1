package app.agentmsg;

import app.util.Path;
import app.util.ViewUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;
import jdk.nashorn.internal.parser.JSONParser;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import static app.util.RequestUtil.removeSessionAttrLoggedOut;
import static app.util.RequestUtil.removeSessionAttrLoginRedirect;

public class AgentmsgController {

    public static Handler processMessage = ctx -> {

        Agentmsg.saveAgentmsg(ctx.body());

        ctx.status(201);

    };

    public static Handler getMessage = ctx -> {
        String host = ctx.queryParam("host");
        String result = AgentmsgDao.getAgentmsgFromDB(host);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);

    };


}
