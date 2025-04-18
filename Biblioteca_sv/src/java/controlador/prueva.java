
package controlador;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;



public class prueva {
     public static void main(String[] args) {
        Connection conn = ConexionDB.getConnection();
        if (conn != null) {
            System.out.println("Conexion Exitosa");
        } else {
            System.out.println("Fallo la conexion");
        }
    }
}
