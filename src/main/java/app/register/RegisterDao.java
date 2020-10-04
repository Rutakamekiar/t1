package app.register;

import app.database.DBconnectionContainer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisterDao {
    public static boolean insertRegister(String email, String login, String pwd) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select * from users where email = ? or login = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1,email);
        preparedStatement.setString(2,login);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next()){
            String sqlInset = "insert into users (login, email, pwd, status, verification) values (?, ?, ?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(sqlInset);
            ps.setString(1,login);
            ps.setString(2,email);
            ps.setString(3,pwd);
            ps.setInt(4,1);
            ps.setInt(5,0);
            ps.executeUpdate();
            connection.commit();
            return true;
        } else {
            return false;
        }
    }
}
