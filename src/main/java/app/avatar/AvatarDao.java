package app.avatar;

import app.database.DBconnectionContainer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AvatarDao {
    public static void setAvatar (String user, String avatar) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String check = "select verification from users where login = ?";
        PreparedStatement statementCheck = connection.prepareStatement(check);
        statementCheck.setString(1,user);
        ResultSet rs = statementCheck.executeQuery();
        if (!rs.next())
            throw new NoSuchFieldException();
        if(rs.getInt("verification") == 0)
            throw new ExceptionInInitializerError();
        String sql = "UPDATE users SET avatar = ? WHERE login = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, avatar);
        preparedStatement.setString(2, user);
        preparedStatement.executeUpdate();
    }

    public static String getAvatar(String login) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "SELECT avatar FROM users WHERE login = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next())
            throw new NoSuchFieldException();
        return rs.getString("avatar");
    }
}
