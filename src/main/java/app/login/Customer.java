package app.login;

import app.database.DBconnectionContainer;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Customer {
    private String login;
    private String password;
    private String email;

    public Customer() {
    }

    public Customer(String login, String password) {
        this.login = login;
        this.password = password;
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

    public static Customer getCustomerFromDB(String login ) throws SQLException, NoSuchFieldException {

        Connection connection = DBconnectionContainer.getDBconnection();
        String sql = "select pwd , verification from users where login = ?;";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, login);
        ResultSet rs = preparedStatement.executeQuery();

        if (!rs.next())
            throw new NoSuchFieldException();

        if(rs.getInt("verification") == 0){
            throw new ExceptionInInitializerError();
        }

        return new Customer(login , rs.getString("pwd"));
    }

}
