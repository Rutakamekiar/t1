package app.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBconnectionContainer {

    private static Connection connection;

    public static Connection getDBconnection() throws SQLException {
        if ( connection == null || connection.isClosed()) {
            String url = "jdbc:postgresql://localhost:5432/postgres";
            Properties props = new Properties();
            props.setProperty("user", "postgres");
            props.setProperty("password", "tss123");
            Connection conn = DriverManager.getConnection(url, props);
            conn.setAutoCommit(false);
            connection = conn;
            return conn;
        }
        return connection;
    }

}
