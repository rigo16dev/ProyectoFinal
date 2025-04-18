<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administrador</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar hidden" id="sidebar">
            
            <ul class="menu" id="menu">
    <!-- Inicio empleado -->
    <li class="menu-item <%= request.getRequestURI().contains("empleado.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/empleado.jsp">Inicio</a>
    </li>

    <!-- Gestión de Clientes -->
    <li class="menu-item <%= request.getRequestURI().contains("Gestion_clientes.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Empleado/Gestion_clientes.jsp">Gestión de Clientes</a>
    </li>

    <!-- Gestión de Libros de la seccion del empleado -->
    <li class="menu-item <%= request.getRequestURI().contains("Gestion_libros2.jsp") ? "active" : "" %>">
        <a href="<%= request.getContextPath() %>/Empleado/Gestion_libros2.jsp">Gestión de Libros</a>
    </li>

    <!-- Cerrar sesión -->
    <li class="menu-item">
        <a href="<%= request.getContextPath() %>/logout.jsp">Cerrar sesión</a>
    </li>
</ul>

        </aside>

        <!-- Contenido principal -->
        <main class="main-content">
           
            <%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>

<section class="topbar">
    <div class="menu-icon" id="menuToggle">☰</div>
    
    <div class="search-box">
        <input type="text" placeholder="Buscar..." />
    </div>

    <div class="profile-pic" id="profileBtn">
       <img src="https://avatars.dicebear.com/api/adventurer/<%= usuario.getNombre() %>.svg" width="40" alt="Perfil" />

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
</section>

            <section class="content-area">
                <!-- Aquí se puede mostrar un resumen general -->
                <h2>Bienvenido al panel de empleado</h2>
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
    </script>
</body>
</html>
