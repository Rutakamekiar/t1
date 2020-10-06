package app.agentmsg;

import app.database.DBconnectionContainer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * Class to work with agent messages in DB
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class AgentmsgDao {

    /**
     * Add message from agent to DB
     * @param uid unique id
     * @param message message from agent in map
     * @throws SQLException
     * @throws ParseException
     * @throws JsonProcessingException
     */
    public static void addAgentmsgToDB( String uid , Map<String,Object> message) throws SQLException, ParseException, JsonProcessingException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "INSERT INTO hosts_info (\"id\", \"host\", \"boot_time\" , \"at\" , \"data\") Values (?, ? , ?, ? , to_json(?::json) )";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, uid);
        preparedStatement.setString(2, message.get("host").toString());
        preparedStatement.setTimestamp(3, dateStringToTimestamp(message.get("boot_time").toString()) );
        preparedStatement.setTimestamp(4, dateStringToTimestamp(message.get("at").toString()) );
        preparedStatement.setString(5, mapToJson( message ));
        preparedStatement.execute();
        connection.commit();
    }

    /**
     * Get last information about host from DB
     * @param host host name to get information about
     * @return String with information about host in json or message that host not found in json
     * @throws SQLException
     */
    public static String getAgentmsgFromDB(String host) throws SQLException{
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select data from hosts_info where at=(select max(at) from hosts_info) and host=?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, host);
        ResultSet rs = preparedStatement.executeQuery( );
        if (!rs.next()) {
            return "{\"result\" : 0,\"message\": \"Host not found\"}";
        }
        else {
            return rs.getString("data");
        }
    }

    /**
     * Transform String date to Timestamp
     * @param date date in String
     * @return date in Timestamp
     * @see Timestamp
     * @throws ParseException
     */
    private static Timestamp dateStringToTimestamp( String date ) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss Z");
        Date dtm = dateFormat.parse(date);
        Timestamp timeStampDate = new Timestamp(dtm.getTime());
        return timeStampDate;
    }

    /**
     * Transform Map message into String with json
     * @param message Map<String,Object> message
     * @return String with message in json
     * @throws JsonProcessingException
     */
    private static String mapToJson( Map<String,Object> message ) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return  mapper.writeValueAsString(message);
    }

}
