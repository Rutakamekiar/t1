package app.agentmsg;

import app.util.Path;
import app.util.ViewUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.javalin.http.Handler;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

import static app.util.RequestUtil.removeSessionAttrLoggedOut;
import static app.util.RequestUtil.removeSessionAttrLoginRedirect;

public class AgentmsgController {

    public static Handler processMessage = ctx -> {

        Agentmsg.saveAgentmsg(ctx.body());

        ctx.json('1');
        ctx.status(201);

    };


}
