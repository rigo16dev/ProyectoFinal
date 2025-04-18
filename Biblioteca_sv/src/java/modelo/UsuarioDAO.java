
package modelo;

import controlador.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {
    
     public Usuario validarUsuario(String email, String password) {
        Connection conn = ConexionDB.getConnection();
        String query = "SELECT u.id_usuario, u.nombre, u.apellido, u.email, u.id_rol, r.nombre AS rol_nombre " +
                       "FROM usuarios u INNER JOIN rol r ON u.id_rol = r.id_rol " +
                       "WHERE u.email = ? AND u.password = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setEmail(rs.getString("email"));
                usuario.setIdRol(rs.getInt("id_rol"));
                usuario.setRolNombre(rs.getString("rol_nombre"));
                return usuario;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //por si no existe 
        return null;
    }
}
