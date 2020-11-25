package app.activecheck;

import app.database.DBconnectionContainer;
import app.login.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

public class ActiveCheckDao {
    public static boolean checkAdd(String user) throws NoSuchFieldException, SQLException {
        int status = Customer.checkUserStatusFromDB(user);
        if (status == 2){
            return true;
        }
        if (status == 1){
            Connection connection = DBconnectionContainer.getDBconnection();
            String sql = "select count(*) from user_link where login = ?;";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1,user);
            ResultSet rs = preparedStatement.executeQuery();
            rs.next();
            if(rs.getInt(1) < 2)
                return true;
            else
                return false;
        }
        return false;
    }

    public static void addLinkToUser(String user, String url) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "insert into user_link values(?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,user);
        preparedStatement.setString(2,url);
        preparedStatement.executeUpdate();
    }

    public static List<String> getAllUrls() throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select distinct url from user_link;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();
        List<String> result = new LinkedList<>();
        while (rs.next()){
            result.add(rs.getString(1));
        }
        return result;
    }

    public static void addResult(String url, int status) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "insert into checks(url,check_date,status) values(?,current_timestamp,?);";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,url);
        preparedStatement.setInt(2,status);
        preparedStatement.executeUpdate();
    }

    public static String getInfo(String user) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select  url, all_check, up from user_link \n" +
                "join (select count(*) all_check, count(status between 200 and 299) up, url from checks group by url) as checked using(url)\n" +
                "where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,user);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next())
            throw new NoSuchFieldException();

        StringBuilder result = new StringBuilder("{ \"uptime\":[ " + "{ \"url\" :\"" + rs.getString(1) + "\"," +
                " \"all_checks\" :\"" + rs.getString(2) + "\"," +
                " \"up\" :\"" + rs.getString(3) + "\"" +
                "}");
        while (rs.next()) {
            result.append( ",{ \"url\" :\"" + rs.getString(1) + "\"," +
                    " \"all_checks\" :\"" + rs.getString(2) + "\"," +
                    " \"up\" :\"" + rs.getString(3) + "\"" +
                    "}");
        }
        return result + "] }";
    }
}
