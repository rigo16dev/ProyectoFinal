package servlets.gestion_admin;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet(name = "EliminarODesabilitarLibro", urlPatterns = {"/EliminarODesabilitarLibro"})
public class eliminarOdesabilitar_libro extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int idLibro = Integer.parseInt(request.getParameter("id"));

            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");

            // Verificar si tiene pr$)A(&stamos
            String sqlCheck = "SELECT COUNT(*) FROM prestamos WHERE id_libro = ?";
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setInt(1, idLibro);
            ResultSet rs = psCheck.executeQuery();
            rs.next();
            int prestamos = rs.getInt(1);
            rs.close();
            psCheck.close();

            if (prestamos > 0) {
                // Desactivar
                String sqlUpdate = "UPDATE libros SET estado_actual = 'Inactivo' WHERE id_libro = ?";
                PreparedStatement psUpdate = con.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, idLibro);
                psUpdate.executeUpdate();
                psUpdate.close();

                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=desactivado");
            } else {
                // Eliminar
                String sqlDelete = "DELETE FROM libros WHERE id_libro = ?";
                PreparedStatement psDelete = con.prepareStatement(sqlDelete);
                psDelete.setInt(1, idLibro);
                psDelete.executeUpdate();
                psDelete.close();

                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=eliminado");
            }

            con.close();

        } catch (Exception e) {
            response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=error");
        }
    }
}
