package app.login;

import app.database.DBconnectionContainer;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class Customer {
    private String login;
    private String password;
    private String status;

    public Customer() {
    }

    public Customer(String login, String password, String status) {
        this.login = login;
        this.password = password;
        this.status = status;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getStatus() { return status; }

    /**
     * Get user-status and password of user with login
     * @param login login of user
     * @return Customer with login, password and status from db
     * @throws SQLException
     * @throws NoSuchFieldException
     */
    public static Customer getCustomerFromDB(String login ) throws SQLException, NoSuchFieldException {

        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select pwd , verification, status from users where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        ResultSet rs = preparedStatement.executeQuery();

        if (!rs.next())
            throw new NoSuchFieldException();

        if(rs.getInt("verification") == 0){
            throw new ExceptionInInitializerError();
        }
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
        return new Customer(login , rs.getString("pwd"), userStatus);
    }

    public static int checkUserStatusFromDB(String login) throws SQLException, NoSuchFieldException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select status from users where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next())
            throw new NoSuchFieldException();
        return rs.getInt("status");
    }

    public static void generateKeys() throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "insert into PremiumKeys values (?);";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        for (int i = 0; i < 10; i++) {
            preparedStatement.setString(1, UUID.randomUUID().toString() );
            preparedStatement.execute();
        }

    }

    public static boolean validateUserCode(String code) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select login from PremiumKeys where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, code );
        System.out.println(preparedStatement);
        ResultSet rs = preparedStatement.executeQuery();
        if (!rs.next())
            return false;
        return true;
    }

    public static void providePremium( String username , String code) throws SQLException {
        Connection connection = DBconnectionContainer.getDBconnection();
        String sql1 = "update users set status = 2 where login = ?;";
        String sql2 = "delete from PremiumKeys where login = ?;";
        PreparedStatement preparedStatement1 = connection.prepareStatement(sql1);
        PreparedStatement preparedStatement2 = connection.prepareStatement(sql2);
        preparedStatement1.setString(1, username );
        preparedStatement2.setString(1, code );
        preparedStatement1.execute();
        preparedStatement2.execute();
    }

}
