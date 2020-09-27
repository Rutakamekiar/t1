package app.agentmsg;

import app.database.DBconnectionContainer;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

public class AgentmsgDao {

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

    private static Timestamp dateStringToTimestamp( String date ) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss Z");
        Date dtm = dateFormat.parse(date);
        Timestamp timeStampDate = new Timestamp(dtm.getTime());
        return timeStampDate;
    }

    private static String mapToJson( Map<String,Object> message ) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return  mapper.writeValueAsString(message);
    }

}
