package app.agentmsg;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import java.util.UUID;

/**
 * Class to work with agent messages
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class Agentmsg {

    /**
     * Transform String message into Map and send it to DB
     * @param msg String message from agent
     * @throws JsonProcessingException
     * @throws ParseException
     * @throws SQLException
     */
    public static void  saveAgentmsg( String msg ) throws JsonProcessingException, ParseException, SQLException {
        ObjectMapper mapper = new ObjectMapper();
        Map<String,Object> message = mapper.readValue(  msg , Map.class);
        AgentmsgDao.addAgentmsgToDB( Agentmsg.getUniqueID() , message );
    }

    /**
     * Generate String id of message
     * @return String id
     */
    private static String getUniqueID(){
       return UUID.randomUUID().toString();
    }

}
