package app.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Class to create connection with data base
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class DBconnectionContainer {

    /**
     * Field that contain connection properties
     * @see Connection
     */
    private static Connection connection;

    /**
     * Return connection to data base or create it if it isn't created
     * @return connection to data base
     * @throws SQLException
     * @see Connection
     */
    public static Connection getDBconnection() throws SQLException {
        if ( connection == null || connection.isClosed()) {
            String url = "jdbc:postgresql://localhost:5432/tss";
            Properties props = new Properties();
            props.setProperty("user", "tssuser");
            props.setProperty("password", "tss123");
            Connection conn = DriverManager.getConnection(url, props);
            conn.setAutoCommit(true);
            connection = conn;
            return conn;
        }
        return connection;
    }

}
