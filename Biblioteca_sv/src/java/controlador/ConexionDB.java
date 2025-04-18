
package controlador;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    private static final String URL = "jdbc:mysql://localhost:3306/Biblioteca_sv";

    private static final String USER = "root";
    private static final String PASSWORD = "";
    private static Connection conn = null;

    //metodo para obtener conexion
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");//cargar el driver
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }
}
