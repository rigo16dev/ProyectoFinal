
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="java.sql.*, java.util.*, modelo.Usuario" %>
<%@ page import="java.sql.*" %>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cliente</title>
        <link rel="stylesheet" type="text/css" href="css/style.css"> <!-- Asegúrate que esta ruta sea correcta -->
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <aside class="sidebar hidden" id="sidebar">

    <ul class="menu" id="menu">
    <!-- Inicio -->
    <li class="menu-item <%= request.getRequestURI().contains("cliente.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/cliente.jsp">Inicio</a>
    </li>

    <!-- Historial de  -->
    <li class="menu-item <%= request.getRequestURI().contains("Pedidos.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Cliente/Pedidos.jsp">Historial de Préstamos</a>
    </li>

    <!-- Soporte / Ayuda -->
    <li class="menu-item <%= request.getRequestURI().contains("Soporte_Ayuda.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Cliente/Soporte_Ayuda.jsp">Soporte / Ayuda</a>
    </li>

    <!-- Cerrar sesión -->
    <li class="menu-item">
        <a href="<%= request.getContextPath() %>/logout.jsp">Cerrar sesión</a>
    </li>
</ul>



            </aside>

            <!-- Contenido principal -->
<main class="main-content">
                <!-- Top bar -->
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>

<section class="topbar">
    <div class="menu-icon" id="menuToggle">☰</div>
    
    <div class="search-box">
        <input type="text" placeholder="Buscar..." />
    </div>
    
    

<div class="profile-pic" id="profileBtn">
    <img src="https://avatars.dicebear.com/api/adventurer/<%= usuario != null ? usuario.getNombre() : "invitado" %>.svg"
         width="40" alt="Perfil" />

    <div class="dropdown-menu" id="dropdownMenu">
        <p><strong>Nombre:</strong> <%= usuario != null ? usuario.getNombre() : "Invitado" %></p>
        <p><strong>Rol:</strong>
            <%
                if (usuario != null) {
                    switch (usuario.getIdRol()) {
                        case 1: out.print("Administrador"); break;
                        case 2: out.print("Empleado"); break;
                        case 3: out.print("Cliente"); break;
                        default: out.print("Desconocido"); break;
                    }
                } else {
                    out.print("Desconocido");
                }
            %>
        </p>
        <form action="<%= request.getContextPath() %>/logout.jsp" method="post">
            <button type="submit">Cerrar sesión</button>
        </form>
    </div>
</div>


    <%-- Comentario temporal para probar Git --%>

</section>

                <!-- Contenido central -->
                <section class="content-area">
                    
                    <!-- Contenido central -->
                    

<div class="orders" style="width: 60%; display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 16px;">
    <%
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/biblioteca_sv", "root", "");
            String sql = "SELECT id_libro, titulo, puntuacion, foto FROM libros WHERE estado_actual = 'Activo'";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int idLibro = rs.getInt("id_libro");
                String titulo = rs.getString("titulo");
                int puntuacion = rs.getInt("puntuacion");
    %>
<div class="card-libro" onclick="mostrarDetalle('<%= idLibro %>', '<%= titulo.replace("'", "\\'") %>', <%= puntuacion %>)">
    <div class="card-img">
        <img src="<%= request.getContextPath() %>/img/libros/<%= rs.getString("foto") %>"
             alt="<%= titulo %>"
             onerror="this.src='<%= request.getContextPath() %>/img/no-imagen.jpg';">
    </div>
    <div class="card-info">
        <h4 title="<%= titulo %>"><%= titulo %></h4>
        <div class="puntuacion">⭐ <%= puntuacion %>/10</div>
    </div>
</div>




    <%
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("<p>Error al cargar libros: " + e.getMessage() + "</p>");
        }
    %>
</div>

<!-- Sección derecha -->
<div class="right-panel" id="detalleLibro" style="width: 40%; background: #f8f8f8; padding: 20px; border-radius: 12px; min-height: 300px;">
    <p style="text-align:center;">Selecciona un libro para ver su información</p>
</div>

                </section>
            </main>
        </div>

    </body>

    <%-- Para el menu desplegable --%>
    <script>
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const menuItems = document.querySelectorAll('.menu-item');

        // Mostrar/ocultar el sidebar
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('hidden');
        });

        // Activar opción seleccionada
        menuItems.forEach(item => {
            item.addEventListener('click', () => {
                menuItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });
    </script>


    <%-- Para el icono desplegable --%>
    <script>
        const profileBtn = document.getElementById('profileBtn');
        const dropdownMenu = document.getElementById('dropdownMenu');

        profileBtn.addEventListener('click', () => {
            dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
        });

        // Opcional: cerrar si haces clic fuera del menú
        window.addEventListener('click', function (e) {
            if (!profileBtn.contains(e.target)) {
                dropdownMenu.style.display = 'none';
            }
        });
    </script>
    
    <script>
function mostrarDetalle(id, titulo, puntuacion) {
    const detalle = document.getElementById("detalleLibro");
    detalle.innerHTML = `
        <div style="text-align:center;">
            <img src="img/libros/${id}.jpg" alt="${titulo}" style="width:150px;">
            <h3>${titulo}</h3>
            <p><strong>Puntuación:</strong> ${puntuacion}/10</p>
            <p>Descripción del libro próximamente aquí...</p>
            <button class="btn-solicitar">Solicitar</button>
        </div>
    `;
}
</script>




</html>
