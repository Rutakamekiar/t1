package app.server;

import app.database.DBconnectionContainer;
import org.postgresql.util.PSQLException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ServerDao {

    public static String getUserServers( String username ) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select host from hosts_servers where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, username);
        ResultSet rs = preparedStatement.executeQuery();

        if (!rs.next())
            throw new NoSuchFieldException();

        String result = "{ \"hosts\":[ " + "{ \"host\" :\"" + rs.getString("host") + "\"}";

        while (rs.next()) {
            result = result + ", { \"host\" :\"" + rs.getString("host") + "\"}";
        }

        return result + "] }";
    }

    public static void addServerToUser( String username , String host) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql1 = "select * from hosts_info where host = ?;";
        PreparedStatement preparedStatement1 = connection.prepareStatement(sql1);
        preparedStatement1.setString(1, host);
        ResultSet rs1 = preparedStatement1.executeQuery();

        if (!rs1.next())
            throw new NoSuchFieldException("there is no such host");

        String sql2 = "insert into hosts_servers values ( ? , ?);";
        PreparedStatement preparedStatement2 = connection.prepareStatement(sql2);
        preparedStatement2.setString(1, username);
        preparedStatement2.setString(2, host);
        preparedStatement2.executeUpdate();
        connection.commit();
    }

    public static void deleteServerFromUser( String username , String host) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();

        String sql = "delete from hosts_servers where login = ? and host = ? ;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, username);
        preparedStatement.setString(2, host);
        preparedStatement.execute();
        connection.commit();
    }

}
