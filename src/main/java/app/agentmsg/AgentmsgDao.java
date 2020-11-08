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
 *
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class AgentmsgDao {

    /**
     * Add message from agent to DB
     *
     * @param uid     unique id
     * @param message message from agent in map
     * @throws SQLException
     * @throws ParseException
     * @throws JsonProcessingException
     */
    public static void addAgentmsgToDB(String uid, Map<String, Object> message) throws SQLException, ParseException, JsonProcessingException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "INSERT INTO hosts_info (\"id\", \"public_key\", \"private_key\", \"host\" , \"boot_time\" , \"at\" , \"data\") Values (?, ? , ? , ? , ?, ? , to_json(?::json) )";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, uid);
        preparedStatement.setString(2, message.get("public_key").toString());
        preparedStatement.setString(3, "empty");
        preparedStatement.setString(4, message.get("host").toString());
        preparedStatement.setTimestamp(5, dateStringToTimestamp(message.get("boot_time").toString()));
        preparedStatement.setTimestamp(6, dateStringToTimestamp(message.get("at").toString()));
        preparedStatement.setString(7, mapToJson(message));
        preparedStatement.execute();

    }

    /**
     * Get last information about host from DB
     *
     * @param public_key host name to get information about
     * @return String with information about host in json or message that host not found in json
     * @throws SQLException
     */
    public static String getAgentmsgFromDB(String public_key, String fromDate, String toDate) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select data from hosts_info " +
                "where at < to_timestamp(?,'YYYY-MM-DD HH24:MI:SS') " +
                "and at > to_timestamp(?,'YYYY-MM-DD HH24:MI:SS') " +
                "and public_key = ? " +
                "order by at;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, toDate);
        preparedStatement.setString(2, fromDate);
        preparedStatement.setString(3, public_key);
        ResultSet rs = preparedStatement.executeQuery();

        if (!rs.next())
            return "{\"result\" : 0,\"message\": \"there is no data for selected period for this Host\"}";
        StringBuilder allobjects = new StringBuilder();
        do {
            allobjects.append(rs.getString("data")).append(",");
        }
        while (rs.next()) ;
        allobjects = new StringBuilder(allobjects.substring(0, allobjects.length() - 1));
        allobjects = new StringBuilder("{ \"data\": [ " + allobjects + "] }");
        return allobjects.toString();
    }


    /**
     * Transform String date to Timestamp
     *
     * @param date date in String
     * @return date in Timestamp
     * @throws ParseException
     * @see Timestamp
     */
    private static Timestamp dateStringToTimestamp(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss Z");
        Date dtm = dateFormat.parse(date);
        Timestamp timeStampDate = new Timestamp(dtm.getTime());
        return timeStampDate;
    }

    /**
     * Transform Map message into String with json
     *
     * @param message Map<String,Object> message
     * @return String with message in json
     * @throws JsonProcessingException
     */
    private static String mapToJson(Map<String, Object> message) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(message);
    }

}
