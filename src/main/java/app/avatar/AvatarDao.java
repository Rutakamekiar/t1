package app.avatar;

import app.database.DBconnectionContainer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Class to connect avatar APIs with DB
 * @author Zhuravlev Yuriu
 * @version 1.0
 */
public class AvatarDao {
    /**
     * Insert users avatar in base64 to db
     * @param user owner of avatar
     * @param avatar avatar in base64
     * @throws SQLException
     * @throws NoSuchFieldException no such user
     */
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

    /**
     * Get avatar in base64
     * @param login owner of avatar
     * @return avatar of user in base64
     * @throws SQLException
     * @throws NoSuchFieldException no such user
     */
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
