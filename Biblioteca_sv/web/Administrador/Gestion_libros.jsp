

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.sql.*, java.util.Calendar" %>
<%@ page import="modelo.Usuario" %>



<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Libros</title>
        <link href="../css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="../css/style_admin.css" type="text/css"/>
    </head>




<body>
<div class="dashboard-container">

<!-- Sidebar -->
<aside class="sidebar hidden" id="sidebar">

<h2>Biblioteca</h2>
<ul class="menu" id="menu">
<!-- Inicio Admin -->
<li class="menu-item <%= request.getRequestURI().contains("admin.jsp") ? "active" : ""%>">
<a href="<%= request.getContextPath()%>/admin.jsp">Inicio</a>
</li>

<!-- Gestión de Categorías -->
<li class="menu-item <%= request.getRequestURI().contains("Gestion_categorias.jsp") ? "active" : ""%>">
<a href="<%= request.getContextPath()%>/Administrador/Gestion_categorias.jsp">Gestión de Categorías</a>
</li>

<!-- Gestión de Libros -->
<li class="menu-item <%= request.getRequestURI().contains("Gestion_libros.jsp") ? "active" : ""%>">
<a href="<%= request.getContextPath()%>/Administrador/Gestion_libros.jsp">Gestión de Libros</a>
</li>

<!-- Cerrar sesión -->
<li class="menu-item">
<a href="<%= request.getContextPath()%>/logout.jsp">Cerrar sesión</a>
</li>
</ul>

</aside>



<!-- Main Content -->
<div class="main-content">
<!-- Top bar -->
<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
if (usuario == null) {
response.sendRedirect(request.getContextPath() + "/index.jsp");
return;
}
%>

<section class="topbar">
<div class="menu-icon" id="menuToggle">☰</div>

<div class="search-box">
<input type="text" placeholder="Buscar..." id="buscadorLibros" />
</div>


<div class="profile-pic" id="profileBtn">
<img src="https://avatars.dicebear.com/api/adventurer/<%= usuario.getNombre()%>.svg" width="40" alt="Perfil" />
<div class="dropdown-menu" id="dropdownMenu">
<p><strong>Nombre:</strong> <%= usuario.getNombre()%></p>
<p><strong>Rol:</strong> 
    <%
        switch (usuario.getIdRol()) {
            case 1:
                out.print("Administrador");
                break;
            case 2:
                out.print("Empleado");
                break;
            case 3:
                out.print("Cliente");
                break;
            default:
                out.print("Desconocido");
                break;
        }
    %>
</p>
<form action="<%= request.getContextPath()%>/logout.jsp" method="post">
    <button type="submit">Cerrar sesión</button>
</form>
</div>
</div>
</section>


<%
String mensaje = request.getParameter("mensaje");
if (mensaje != null && !mensaje.isEmpty()) {
%>
<div style="background-color: #e0ffe0; color: #006600; padding: 10px; margin-bottom: 10px; border-radius: 5px;">
<%= mensaje%>
</div>
<%
}
%>

<!-- Zona principal -->
<div class="orders">
<h2>Agregar Libro</h2>
<div class="header-acciones">
<button class="btn-nuevo" onclick="abrirModal()">+ Nuevo Libro</button>
</div>


<table class="tabla-libros" id="tablaLibros">

<thead>
<tr>
    <th>ID</th>
    <th>NOMBRE</th>
    <th>IMAGEN</th>
    <th>DESCRIPCIÓN</th>
    <th>AÑO</th>
    <th>CANTIDAD</th>
    <th>CATEGORÍA</th>
    <th>ESTADO</th>
    <th>ACCIONES</th>
</tr>
</thead>
<tbody>
<%
    String busqueda = request.getParameter("buscar");
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");

        String sql = "SELECT l.*, c.nombre AS categoria_nombre "
                + "FROM libros l INNER JOIN categorias c ON l.id_categoria = c.id_categoria";

        PreparedStatement ps;

        if (busqueda != null && !busqueda.trim().isEmpty()) {
            sql += " WHERE LOWER(l.titulo) LIKE ? OR LOWER(l.autor) LIKE ?";
            ps = con.prepareStatement(sql);
            String filtro = "%" + busqueda.toLowerCase() + "%";
            ps.setString(1, filtro);
            ps.setString(2, filtro);
        } else {
            ps = con.prepareStatement(sql);
        }

        ResultSet rs = ps.executeQuery();

        boolean hayResultados = false;
        while (rs.next()) {
            hayResultados = true;
%>
<tr>
    <td><%= rs.getInt("id_libro")%></td>
    <td><%= rs.getString("titulo")%></td>
    <td>

        <img src="<%= request.getContextPath() + "/" + rs.getString("foto")%>" alt="Imagen del libro">



    </td>
    <td><%= rs.getString("descripcion")%></td>
    <td><%= rs.getInt("anio_publicacion")%></td>
    <td><%= rs.getInt("cantidad")%></td>
    <td><%= rs.getString("categoria_nombre")%></td>
    <td><%= rs.getString("estado")%></td>
    <td>
        <form method="post" action="../EliminarODesabilitarLibro" onsubmit="return confirm('¿Estás seguro que deseas eliminar este libro?');" style="display:inline;">
            <input type="hidden" name="id" value="<%= rs.getInt("id_libro")%>">
            <button type="submit" class="btn-eliminar">🗑️</button>
        </form>


        <button 
            <button 


                <button 
                    type="button" 
                    class="btn-editar"
                    onclick='abrirModalEditar(
"<%= rs.getInt("id_libro")%>",
"<%= rs.getString("titulo").replace("\"", "\\\"")%>",
"<%= rs.getString("autor").replace("\"", "\\\"")%>",
"<%= rs.getInt("anio_publicacion")%>",
"<%= rs.getInt("cantidad")%>",
"<%= rs.getString("descripcion").replace("\"", "\\\"")%>",
"<%= rs.getInt("id_categoria")%>",
"<%= rs.getString("estado")%>",
"<%= rs.getString("estado_actual")%>"  // nuevo campo agregado
)'>✏️</button>




                </td>

                </tr>
                <%
                    }

                    if (!hayResultados) {
                %>
                <tr><td colspan="9">No se encontraron resultados.</td></tr>
                <%
                        }

                        rs.close();
                        ps.close();
                        con.close();

                    } catch (Exception e) {
                        out.println("<tr><td colspan='9'>Error al buscar libros: " + e.getMessage() + "</td></tr>");
                    }
                %>



</tbody>
</table>
</div>
</div>
</div>


    <!-- MODAL PARA AGREGAR LIBROS DESDE EL ADMINISTRADOR Y EMPLEADO -->
    <div id="modalAgregarLibro" class="modal">
        <div class="modal-contenido">
            <span class="cerrar" onclick="cerrarModal()">&times;</span>
            <h2>Agregar Libro</h2>

            <form action="../AgregarLibro" method="post" enctype="multipart/form-data" class="formulario-libro">
                <div class="form-group">
                    <input type="text" name="titulo" placeholder="Título del libro" required maxlength="100">
                    <input type="text" name="autor" placeholder="Autor" required maxlength="100">
                </div>

                <div class="form-group">
                    <select name="anio" required>
                        <option value="">Año de publicación</option>
                        <%
                            int anioActual = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                            for (int i = anioActual; i >= 1500; i--) {
                        %>
                        <option value="<%= i%>"><%= i%></option>
                        <%
                            }
                        %>
                    </select>


                    <input type="number" name="cantidad" placeholder="Cantidad disponible" required min="1" step="1">
                </div>

                <div class="form-group">
                    <select name="estado" required>
                        <option value="">Estado</option>
                        <option value="Normal">Normal</option>
                        <option value="Malo">Malo</option>
                    </select>

                    <select name="categoria" required>
                        <option value="">Seleccione categoría</option>
                        <%
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM categorias");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id_categoria")%>"><%= rs.getString("nombre")%></option>
                        <%
                                }
                                con.close();
                            } catch (Exception e) {
                                out.println("Error al cargar categorías");
                            }
                        %>
                    </select>
                </div>

                <textarea name="descripcion" placeholder="Descripción del libro" rows="3" maxlength="1000"></textarea>
                <div class="form-group">
                    <input type="number" name="puntuacion" placeholder="Puntuación del libro (1-10)" required min="1" max="10" step="1">
                </div>


                <div class="form-group">
                    <input type="file" name="imagen" accept="image/png, image/jpeg" required>
                </div>

                <button type="submit" class="btn-agregar">Guardar libro</button>
            </form>
        </div>
    </div>



    <!-- MODAL PARA EDITAR LIBROS DESDE EL ADMINISTRADOR O EMPLEADO  -->
    <div id="modalEditarLibro" class="modal">
        <div class="modal-contenido">
            <span class="cerrar" onclick="cerrarModalEditar()">&times;</span>
            <h2>Editar Libro</h2>
            <form action="../Editar_libro" method="post" enctype="multipart/form-data" class="formulario-libro">


                <input type="hidden" name="id" id="editId">
                <div class="form-group">
                    <input type="text" name="titulo" id="editTitulo" placeholder="Título del libro" required maxlength="100">
                    <input type="text" name="autor" id="editAutor" placeholder="Autor" required maxlength="100">
                </div>
                <div class="form-group">
                    <select name="anio" id="editAnio" required>
                        <option value="">Año de publicación</option>
                        <%
                            int anioActualEditar = Calendar.getInstance().get(Calendar.YEAR);
                            for (int i = anioActualEditar; i >= 1500; i--) {
                        %>
                        <option value="<%= i%>"><%= i%></option>
                        <% } %>
                    </select>
                    <input type="number" name="cantidad" id="editCantidad" placeholder="Cantidad disponible" required min="1" step="1">
                </div>
                <div class="form-group">
                    <select name="estado" id="editEstado" required>
                        <option value="">Estado</option>
                        <option value="Normal">Normal</option>
                        <option value="Malo">Malo</option>


                    </select>

                    <select name="estado_actual" id="editEstadoActual" required>
                        <option value="">Estado actual</option>
                        <option value="Activo">Activo</option>
                        <option value="Inactivo">Inactivo</option>
                    </select>


                    <select name="categoria" id="editCategoria" required>
                        <option value="">Seleccione categoría</option>
                        <% try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");
                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM categorias");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id_categoria")%>"><%= rs.getString("nombre")%></option>
                        <% }
                                con.close();
                            } catch (Exception e) {
                                out.println("Error al cargar categorías");
}%>
                    </select>
                </div>
                <textarea name="descripcion" id="editDescripcion" placeholder="Descripción del libro" rows="3" maxlength="1000"></textarea>
                <div class="form-group">
                    <input type="number" name="puntuacion" id="editPuntuacion" placeholder="Puntuación (1-10)" required min="1" max="10" step="1">

                    <div class="form-group">
                        <label for="editImagen">Cambiar imagen (opcional):</label>
                        <input type="file" name="imagen" id="editImagen" accept="image/*">
                    </div>

                </div>

                <button type="submit" class="btn-editar">Actualizar libro</button>
            </form>
        </div>
    </div>

    <!-- Scripts para el despliege de menus y modales de la pagina-->
    <script>
        function abrirModalEditar(id, titulo, autor, anio, cantidad, descripcion, idCategoria, estado, estadoActual) {
            document.getElementById('editId').value = id;
            document.getElementById('editTitulo').value = titulo;
            document.getElementById('editAutor').value = autor;
            document.getElementById('editAnio').value = anio;
            document.getElementById('editCantidad').value = cantidad;
            document.getElementById('editDescripcion').value = descripcion;
            document.getElementById('editCategoria').value = idCategoria;
            document.getElementById('editEstado').value = estado;
            document.getElementById('editEstadoActual').value = estadoActual;
            document.getElementById('modalEditarLibro').style.display = 'block';
        }


        function cerrarModalEditar() {
            document.getElementById('modalEditarLibro').style.display = 'none';
        }
    </script>


    <!-- Scripts -->
    <script>
        function abrirModal() {
            document.getElementById("modalAgregarLibro").style.display = "block";
        }

        function cerrarModal() {
            document.getElementById("modalAgregarLibro").style.display = "none";
        }

        window.onclick = function (event) {
            const modal = document.getElementById("modalAgregarLibro");
            if (event.target === modal) {
                modal.style.display = "none";
            }
        }
    </script>




    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const input = document.getElementById("buscadorLibros");
            const tabla = document.getElementById("tablaLibros").getElementsByTagName("tbody")[0];
            const filas = tabla.getElementsByTagName("tr");

            input.addEventListener("keyup", function () {
                const filtro = input.value.toLowerCase();

                for (let i = 0; i < filas.length; i++) {
                    const texto = filas[i].textContent.toLowerCase();
                    filas[i].style.display = texto.includes(filtro) ? "" : "none";
                }
            });
        });
    </script>



    </body>

    <!-- Scripts para el sidebar de el usuario -->
    <script>
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const menuItems = document.querySelectorAll('.menu-item');

        
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('hidden');
            localStorage.setItem("sidebar_oculto", sidebar.classList.contains("hidden"));
        });

        // restaurar estado al cargar
        window.addEventListener('DOMContentLoaded', () => {
            const oculto = localStorage.getItem("sidebar_oculto");
            if (oculto === "true") {
                sidebar.classList.add("hidden");
            }
        });


        menuItems.forEach(item => {
            item.addEventListener('click', () => {
                menuItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });
    </script>
</html>
