package servlets.gestion_admin;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.sql.*;

@WebServlet(name = "EditarLibro", urlPatterns = {"/Editar_libro"})
@MultipartConfig
public class Editar_libro extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int idLibro = Integer.parseInt(request.getParameter("id"));
            String titulo = request.getParameter("titulo");
            String autor = request.getParameter("autor");
            int anio = Integer.parseInt(request.getParameter("anio"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            String estado = request.getParameter("estado");
            int idCategoria = Integer.parseInt(request.getParameter("categoria"));
            String descripcion = request.getParameter("descripcion");
            String puntuacionStr = request.getParameter("puntuacion");

            // Validaciones
            if (titulo == null || titulo.trim().isEmpty() || titulo.length() > 100
                    || autor == null || autor.trim().isEmpty() || autor.length() > 100
                    || descripcion == null || descripcion.length() > 1000
                    || puntuacionStr == null || puntuacionStr.trim().isEmpty()
                    || anio < 1500 || anio > 2099 || cantidad < 1
                    || (!estado.equals("Normal") && !estado.equals("Da?ado"))) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Datos inv$)A("lidos.");
                return;
            }
            int puntuacion;
            try {
                puntuacion = Integer.parseInt(puntuacionStr);
                if (puntuacion < 1 || puntuacion > 10) {
                    response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=La puntuaci$)A(.n debe estar entre 1 y 10.");
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Puntuaci$)A(.n no v("lida.");
                return;
            }

            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");

            String sql = "UPDATE libros SET titulo=?, autor=?, anio_publicacion=?, cantidad=?, estado=?, id_categoria=?, descripcion=?, puntuacion=? WHERE id_libro=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, titulo);
            ps.setString(2, autor);
            ps.setInt(3, anio);
            ps.setInt(4, cantidad);
            ps.setString(5, estado);
            ps.setInt(6, idCategoria);
            ps.setString(7, descripcion);
            ps.setInt(8, puntuacion);
            ps.setInt(9, idLibro);

            int filas = ps.executeUpdate();
            ps.close();
            con.close();

            if (filas > 0) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Libro actualizado correctamente.");
            } else {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=No se encontr$)A(. el libro.");
            }

        } catch (Exception e) {
            response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error al actualizar: " + e.getMessage());
        }
    }
}
