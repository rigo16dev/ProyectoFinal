package servlets.gestion_admin;

import java.io.*;
import java.nio.file.Paths;
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
        String estado = request.getParameter("estado").trim();
        String estadoActual = request.getParameter("estado_actual").trim();
        int idCategoria = Integer.parseInt(request.getParameter("categoria"));
        String descripcion = request.getParameter("descripcion");
        String puntuacionStr = request.getParameter("puntuacion");

        // Validaciones
        if (titulo == null || titulo.trim().isEmpty() || titulo.length() > 100
                || autor == null || autor.trim().isEmpty() || autor.length() > 100
                || descripcion == null || descripcion.length() > 1000
                || puntuacionStr == null || puntuacionStr.trim().isEmpty()
                || anio < 1500 || anio > 2099 || cantidad < 1
                || estado == null || !(estado.equalsIgnoreCase("Normal") || estado.equalsIgnoreCase("Malo"))
                || estadoActual == null || !(estadoActual.equalsIgnoreCase("Activo") || estadoActual.equalsIgnoreCase("Inactivo"))) {
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

        // Imagen (opcional)
        Part imagenPart = request.getPart("imagen");
        String nombreImagen = null;

        if (imagenPart != null && imagenPart.getSize() > 0) {
            String nombreArchivo = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();
            String rutaGuardado = getServletContext().getRealPath("/img/libros");
            File carpeta = new File(rutaGuardado);
            if (!carpeta.exists()) carpeta.mkdirs();

            imagenPart.write(rutaGuardado + File.separator + nombreArchivo);
            nombreImagen = "img/libros/" + nombreArchivo;
        }

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");

        String sql;
        PreparedStatement ps;

        if (nombreImagen != null) {
            sql = "UPDATE libros SET titulo=?, autor=?, anio_publicacion=?, cantidad=?, estado=?, estado_actual=?, id_categoria=?, descripcion=?, puntuacion=?, foto=? WHERE id_libro=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, titulo);
            ps.setString(2, autor);
            ps.setInt(3, anio);
            ps.setInt(4, cantidad);
            ps.setString(5, estado);
            ps.setString(6, estadoActual);
            ps.setInt(7, idCategoria);
            ps.setString(8, descripcion);
            ps.setInt(9, puntuacion);
            ps.setString(10, nombreImagen);
            ps.setInt(11, idLibro);
        } else {
            sql = "UPDATE libros SET titulo=?, autor=?, anio_publicacion=?, cantidad=?, estado=?, estado_actual=?, id_categoria=?, descripcion=?, puntuacion=? WHERE id_libro=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, titulo);
            ps.setString(2, autor);
            ps.setInt(3, anio);
            ps.setInt(4, cantidad);
            ps.setString(5, estado);
            ps.setString(6, estadoActual);
            ps.setInt(7, idCategoria);
            ps.setString(8, descripcion);
            ps.setInt(9, puntuacion);
            ps.setInt(10, idLibro);
        }

        int filas = ps.executeUpdate();
        ps.close();
        con.close();

        if (filas > 0) {
            response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Libro actualizado correctamente.");
        } else {
            response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=No se encontr$)A(. el libro.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error al actualizar: " + e.getMessage());
    }
}

}
