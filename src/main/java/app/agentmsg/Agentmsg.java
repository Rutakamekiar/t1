package app.agentmsg;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import java.util.UUID;

public class Agentmsg {

    public static void  saveAgentmsg( String msg ) throws JsonProcessingException, ParseException, SQLException {
        ObjectMapper mapper = new ObjectMapper();
        Map<String,Object> message = mapper.readValue(  msg , Map.class);
        AgentmsgDao.addAgentmsgToDB( Agentmsg.getUniqueID() , message );
    }

    private static String getUniqueID(){
       return UUID.randomUUID().toString();
    }

}
