package servlets.gestion_admin;

import java.io.*;
import java.nio.file.Paths;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet(name = "AgregarLibro", urlPatterns = {"/AgregarLibro"})
@MultipartConfig
public class Agregar_libro extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Validar y obtener datos del formulario
            String titulo = request.getParameter("titulo");
            String autor = request.getParameter("autor");
            String anioStr = request.getParameter("anio");
            String cantidadStr = request.getParameter("cantidad");
            String estado = request.getParameter("estado");
            String idCategoriaStr = request.getParameter("categoria");
            String descripcion = request.getParameter("descripcion");
            String puntuacionStr = request.getParameter("puntuacion");

            if (titulo == null || titulo.trim().isEmpty() || titulo.length() > 100
                    || autor == null || autor.trim().isEmpty() || autor.length() > 100
                    || anioStr == null || cantidadStr == null || estado == null
                    || idCategoriaStr == null || descripcion == null || descripcion.length() > 1000
                    || puntuacionStr == null || puntuacionStr.trim().isEmpty()) {

                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: Datos incompletos o inv$)A("lidos.");
                return;
            }

            // Convertir datos num$)A(&ricos
            int anio, cantidad, idCategoria;
            try {
                anio = Integer.parseInt(anioStr);
                cantidad = Integer.parseInt(cantidadStr);
                idCategoria = Integer.parseInt(idCategoriaStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: A?o o cantidad no v$)A("lidos.");
                return;
            }
            int puntuacion;
            try {
                puntuacion = Integer.parseInt(puntuacionStr);
                if (puntuacion < 1 || puntuacion > 10) {
                    response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: La puntuaci$)A(.n debe estar entre 1 y 10.");
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: Puntuaci$)A(.n no v("lida.");
                return;
            }

            if (anio < 1500 || anio > 2099 || cantidad <= 0) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: A?o o cantidad fuera de rango.");
                return;
            }

            if (!estado.equals("Normal") && !estado.equals("Da?ado")) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: Estado no v$)A("lido.");
                return;
            }

            // Manejo de imagen
            Part filePart = request.getPart("imagen");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: Debes seleccionar una imagen.");
                return;
            }

            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = fileName.toLowerCase();

            if (!extension.endsWith(".jpg") && !extension.endsWith(".jpeg") && !extension.endsWith(".png")) {
                response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: Imagen debe ser JPG o PNG.");
                return;
            }

            // Guardar imagen con nombre $)A(2nico
            String uploadPath = getServletContext().getRealPath("/img/libros/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + uniqueFileName);

            // Conexi$)A(.n e inserci(.n a base de datos
            Class.forName("com.mysql.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "")) {

                String sql = "INSERT INTO libros (titulo, autor, anio_publicacion, cantidad, estado, id_categoria, foto, descripcion, puntuacion, estado_actual) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Activo')";

                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, titulo);
                ps.setString(2, autor);
                ps.setInt(3, anio);
                ps.setInt(4, cantidad);
                ps.setString(5, estado);
                ps.setInt(6, idCategoria);
                ps.setString(7, uniqueFileName);
                ps.setString(8, descripcion);
                ps.setInt(9, puntuacion);

                int result = ps.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Libro agregado correctamente.");
                } else {
                    response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error: No se pudo agregar el libro.");
                }
            }

        } catch (Exception e) {
            response.sendRedirect("Administrador/Gestion_libros.jsp?mensaje=Error al procesar el libro: " + e.getMessage());
        }
    }
}
