package app.register;

import app.database.DBconnectionContainer;
import app.util.PasswordGenerator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class RegisterDao {
    public static boolean insertRegister(String email, String login, String pwd, String token) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select * from users where email = ? or login = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,email);
        preparedStatement.setString(2,login);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next()){
            String sqlInset = "insert into users (login, email, pwd, status, verification, ver_token) values (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(sqlInset);
            ps.setString(1,login);
            ps.setString(2,email);
            ps.setString(3,pwd);
            ps.setInt(4,1);
            ps.setInt(5,0);
            ps.setString(6, token);
            ps.executeUpdate();
            connection.commit();
            return true;
        } else {
            return false;
        }
    }
    public static void verifyEmail(String token) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "update users set verification = 1 where ver_token = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,token);
        preparedStatement.executeUpdate();
        connection.commit();
    }
    public static String dropPass(String email, String newPassword ) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String check = "select verification from users where email = ?";
        PreparedStatement statementCheck = connection.prepareStatement(check);
        statementCheck.setString(1,email);
        ResultSet rs = statementCheck.executeQuery();
        String result;
        if (rs.next()) {
            if (rs.getInt("verification")==0){
                result = "{\"result\" : 1,\"message\": \"Email is not verified\"}";
            } else {
                String sql = "update users set pwd = ? where email = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, newPassword);
                preparedStatement.setString(2, email);
                preparedStatement.executeUpdate();
                connection.commit();
                result = "{\"result\" : 2,\"message\": \"Password dropped check email\"}";
            }
        }   else {
            result = "{\"result\" : 0,\"message\": \"Such email does not exist\"}";
        }
        return result;
    }
}
