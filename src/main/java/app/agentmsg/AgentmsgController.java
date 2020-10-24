package app.agentmsg;

import app.util.Path;
import app.util.ViewUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import static app.util.RequestUtil.removeSessionAttrLoggedOut;
import static app.util.RequestUtil.removeSessionAttrLoginRedirect;

/**
 * Class controller to work with agent messages
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class AgentmsgController {

    /**
     * Save message from agent to DB API
     * @see Handler
     */
    public static Handler processMessage = ctx -> {
        Agentmsg.saveAgentmsg(ctx.body());
        ctx.status(201);
    };
    /**
     * Send agent message to front API
     * @see Handler
     */
    public static Handler getMessage = ctx -> {
        String host = ctx.queryParam("host");
        String fromDate = ctx.queryParam("from");
        String toDate = ctx.queryParam("to");
        String result = AgentmsgDao.getAgentmsgFromDB(host , fromDate, toDate);
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(result);
        ctx.header("Access-Control-Allow-Origin","*");
        ctx.json(jsonNode);
        ctx.status(201);

    };


}
