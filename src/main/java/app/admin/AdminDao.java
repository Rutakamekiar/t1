package app.admin;

import app.database.DBconnectionContainer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDao {
    public static String getAllUsers() throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select login, status, verification, case when avatar is null then 'empty' else 'not empty' end as av from users where status != 3";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        StringBuilder resultJson = new StringBuilder("{\"result\" : 1, \"message\": \"all users\", \"users\" : [");
        while (rs.next()){
            String userStatus;
            switch (rs.getInt("status")){
                case 1:
                    userStatus = "free";
                    break;
                case 2:
                    userStatus = "premium";
                    break;
                case 3:
                    userStatus = "admin";
                    break;
                default:
                    userStatus = "strange status";
                    break;
            }
            String verificationStatus;
            if (rs.getInt("verification")==1)
                verificationStatus="verificated";
            else
                verificationStatus="not verificated";
            resultJson.append("{ \"login\": \"").append(rs.getString("login")).append("\", \"user-status\": \"")
                    .append(userStatus).append("\", \"verification-status\": \"").append(verificationStatus).append("\", \"avatar\": \""+rs.getString("av")+"\" },");
        }
        resultJson.deleteCharAt(resultJson.length()-1);
        resultJson.append("]}");
        return resultJson.toString();
    }

    public static void changeStatus(String login, int status) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "update users set status = ? where login = ? and status != 3";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1,status);
        preparedStatement.setString(2, login);
        preparedStatement.executeUpdate();
    }

    public static void dropAvatar(String login) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "update users set avatar = NULL where login = ? and status != 3";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        preparedStatement.executeUpdate();
    }

    public static void dropUserHosts(String login) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "delete from hosts_servers where login = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        preparedStatement.executeUpdate();
    }
}
