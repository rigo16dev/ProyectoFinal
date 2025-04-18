<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Categorías</title>
    <link href="../css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="../css/style_admin.css" type="text/css"/>
</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar hidden" id="sidebar">
        <ul class="menu" id="menu">
    <!-- Inicio Admin -->
    <li class="menu-item <%= request.getRequestURI().contains("admin.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/admin.jsp">Inicio</a>
    </li>

    <!-- Gestión de Categorías -->
    <li class="menu-item <%= request.getRequestURI().contains("Gestion_categorias.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Administrador/Gestion_categorias.jsp">Gestión de Categorías</a>
    </li>

    <!-- Gestión de Libros -->
    <li class="menu-item <%= request.getRequestURI().contains("Gestion_libros.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Administrador/Gestion_libros.jsp">Gestión de Libros</a>
    </li>

    <!-- Cerrar sesión -->
    <li class="menu-item">
        <a href="<%= request.getContextPath() %>/logout.jsp">Cerrar sesión</a>
    </li>
</ul>

    </aside>

    <!-- Main -->
    <main class="main-content">
        <!-- Topbar -->
        <section class="topbar">
            <div class="menu-icon" id="menuToggle">☰</div>
            <div class="search-box">
                <input type="text" id="searchInput" class="search-input" placeholder="Buscar categoría...">
            </div>
            <div class="profile-pic" id="profileBtn">
                <img src="https://placekitten.com/40/40" alt="Perfil" />
                <div class="dropdown-menu" id="dropdownMenu">
                    <p><strong>Nombre:</strong> Admin</p>
                    <p><strong>Rol:</strong> Administrador</p>
                    <form action="../logout.jsp" method="post">
                        <button type="submit">Cerrar sesión</button>
                    </form>
                </div>
            </div>
        </section>

        <!-- Content Area -->
        <section class="admin-panel scrollable">
            <div class="admin-header">
                <h2>Categorías</h2>
                <% String mensaje = request.getParameter("mensaje");
                   if (mensaje != null && !mensaje.isEmpty()) { %>
                    <div class="alert-success" id="mensajeAlert"><%= mensaje %></div>
                <% } %>
            </div>

            <form class="form-inline" action="Gestion_categorias.jsp" method="post">
                <input type="hidden" name="accion" value="agregar">
                <input type="text" name="nombre" class="input-field" placeholder="Nueva categoría" required>
                <button type="submit" class="btn btn-primary">Agregar</button>
            </form>

            <div class="table-wrapper">
                <table class="styled-table" id="tablaCategorias">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection con = null;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                con = DriverManager.getConnection("jdbc:mysql://localhost/biblioteca_sv", "root", "");

                                String accion = request.getParameter("accion");
                                if (accion != null) {
                                    String mensajeLocal = "";
                                    if ("agregar".equals(accion)) {
                                        String nombre = request.getParameter("nombre");
                                        PreparedStatement check = con.prepareStatement("SELECT COUNT(*) FROM categorias WHERE nombre = ?");
                                        check.setString(1, nombre);
                                        ResultSet rsCheck = check.executeQuery();
                                        rsCheck.next();
                                        if (rsCheck.getInt(1) > 0) {
                                            response.sendRedirect("Gestion_categorias.jsp?mensaje=" + java.net.URLEncoder.encode("¡La categoría ya existe!", "UTF-8"));
                                            return;
                                        } else {
                                            PreparedStatement insert = con.prepareStatement("INSERT INTO categorias(nombre) VALUES(?)");
                                            insert.setString(1, nombre);
                                            insert.executeUpdate();
                                            response.sendRedirect("Gestion_categorias.jsp?mensaje=" + java.net.URLEncoder.encode("Categoría agregada exitosamente.", "UTF-8"));
                                            return;
                                        }
                                    }
                                    if ("editar".equals(accion)) {
                                        int id = Integer.parseInt(request.getParameter("id_categoria"));
                                        String nuevoNombre = request.getParameter("nuevo_nombre");
                                        PreparedStatement check = con.prepareStatement("SELECT COUNT(*) FROM categorias WHERE nombre = ?");
                                        check.setString(1, nuevoNombre);
                                        ResultSet rsCheck = check.executeQuery();
                                        rsCheck.next();
                                        if (rsCheck.getInt(1) > 0) {
                                            response.sendRedirect("Gestion_categorias.jsp?mensaje=" + java.net.URLEncoder.encode("¡Ya existe una categoría con ese nombre!", "UTF-8"));
                                            return;
                                        } else {
                                            PreparedStatement update = con.prepareStatement("UPDATE categorias SET nombre = ? WHERE id_categoria = ?");
                                            update.setString(1, nuevoNombre);
                                            update.setInt(2, id);
                                            update.executeUpdate();
                                            response.sendRedirect("Gestion_categorias.jsp?mensaje=" + java.net.URLEncoder.encode("Categoría actualizada correctamente.", "UTF-8"));
                                            return;
                                        }
                                    }
                                }

                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery("SELECT * FROM categorias");
                                while(rs.next()) {
                                    int id = rs.getInt("id_categoria");
                                    String nombre = rs.getString("nombre");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=nombre%></td>
                            <td>
                                <form action="Gestion_categorias.jsp" method="post" class="form-inline">
                                    <input type="hidden" name="accion" value="editar">
                                    <input type="hidden" name="id_categoria" value="<%=id%>">
                                    <input type="text" name="nuevo_nombre" class="input-field small" placeholder="Nuevo nombre" required>
                                    <button type="submit" class="btn btn-secondary">Editar</button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.println("Error al cargar categorías: " + e.getMessage());
                            } finally {
                                if (con != null) try { con.close(); } catch(Exception ex) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<!-- Scripts -->
<script>
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const menuItems = document.querySelectorAll('.menu-item');

    menuToggle.addEventListener('click', () => {
        sidebar.classList.toggle('hidden');
    });

    menuItems.forEach(item => {
        item.addEventListener('click', () => {
            menuItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');
        });
    });

    const profileBtn = document.getElementById('profileBtn');
    const dropdownMenu = document.getElementById('dropdownMenu');

    profileBtn.addEventListener('click', () => {
        dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
    });

    window.addEventListener('click', function (e) {
        if (!profileBtn.contains(e.target)) {
            dropdownMenu.style.display = 'none';
        }
    });

    // Búsqueda (funciona solo desde el topbar ahora)
    const searchInput = document.getElementById("searchInput");
    const table = document.getElementById("tablaCategorias");

    searchInput.addEventListener("keyup", function () {
        const value = this.value.toLowerCase();
        const rows = table.getElementsByTagName("tr");

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(value) ? "" : "none";
        }
    });

    // Ocultar mensaje después de 2 segundos
    setTimeout(() => {
        const mensajeAlert = document.getElementById('mensajeAlert');
        if (mensajeAlert) {
            mensajeAlert.classList.add('alert-hide');
        }
    }, 2000);
</script>
</body>
</html>
