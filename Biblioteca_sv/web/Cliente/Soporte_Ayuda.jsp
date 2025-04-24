<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cliente</title>
        <link rel="stylesheet" href="../css/style.css">

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

    <!-- Historial de Préstamos -->
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
                <section class="topbar">
                    <div class="menu-icon" id="menuToggle">☰</div>
                    <div class="search-box">
                        <input type="text" placeholder="Buscar..." />
                    </div>

                    <div class="profile-pic" id="profileBtn">
                        <img src="https://i.pravatar.cc/40" alt="Perfil" />
                        <div class="dropdown-menu" id="dropdownMenu">
                            <p><strong>Nombre:</strong> Juan Pérez</p>
                            <p><strong>Rol:</strong> Cliente</p>
                            <form action="logout.jsp" method="post">
                                <button type="submit">Cerrar sesión</button>
                            </form>
                        </div>
                    </div>


                </section>

                <!-- Contenido central -->
                <section class="content-area">
                    <!-- Tabla u ordenes -->
                    <div class="orders">
                        <!-- Contenido central -->
                    </div>

                    <!-- Sección derecha -->
                    <div class="right-panel">
                        <!-- Clientes recientes -->
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


    <%-- Para el icono desplegable de el usuario--%>
    <script>
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



</html>
