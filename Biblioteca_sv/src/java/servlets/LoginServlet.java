package servlets;

import modelo.Usuario;
import modelo.UsuarioDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.validarUsuario(email, password);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            switch (usuario.getIdRol()) {
                case 1:
                    //por si los datos son de admin
                    response.sendRedirect("admin.jsp");
                    break;
                case 2:
                    //por si los datos son de empleado
                    response.sendRedirect("empleado.jsp");
                    break;
                case 3:
                    //por si los datos son de cliente
                    response.sendRedirect("cliente.jsp");
                    break;
                default:
                    //por si no existen esos datos 
                    response.sendRedirect("index.jsp?error=1");
            }
        } else {
            //en caso de aver un errir
            response.sendRedirect("index.jsp?error=1");
        }
    }
}
