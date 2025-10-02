<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("portalempleados");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clientes | Gestión de clientes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCL.css">
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar" id="sidebar">
                <div style="text-align: center;">
                    <img src="${pageContext.request.contextPath}/images/StylishHome.jpg" 
                         alt="Imagen corporativa" style="height: 14rem;">
                </div>
                <ul class="nav flex-column px-3">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/clientes">
                            <i class="fas fa-users"></i> Clientes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-box"></i> Productos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice"></i> Cotizaciones
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice"></i> Pedidos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice-dollar"></i> Facturación
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-chart-line"></i> Informes
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
            <div class="main-content flex-grow-1" id="mainContent">
                <nav class="navbar navbar-custom mb-4 d-flex">
                    <div class="container-fluid">
                        <div class="d-flex align-items-center">
                            <button class="toggle-sidebar me-3" id="toggleSidebar">
                                <i class="fas fa-bars"></i>
                            </button>
                            <h4 class="mb-0">Gestión de Cliente</h4>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="input-group me-3" style="width: 250px;">
                                <input type="text" class="form-control" placeholder="Buscar...">
                                <button class="btn btn-outline-secondary" type="button">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                            <div class="dropdown me-3">
                                <button class="btn btn-light dropdown-toggle position-relative" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                                    <i class="fas fa-bell"></i>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">4</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationsDropdown">
                                    <li><h6 class="dropdown-header">Notificaciones</h6></li>
                                    <li><a class="dropdown-item" href="#">COT-2025-00123 vencida</a></li>
                                    <li><a class="dropdown-item" href="#">Stock bajo en cerámicas madrid</a></li>
                                    <li><a class="dropdown-item" href="#">Pedido PED-2025-00125 facturado</a></li>
                                    <li><a class="dropdown-item" href="#">Actualización del sistema</a></li>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-light dropdown-toggle d-flex align-items-center" type="button" id="userDropdown" data-bs-toggle="dropdown">
                                    <div class="me-2 d-none d-md-block">
                                        <small class="text-muted">${not empty rolUsuario ? rolUsuario : 'Asesor Comercial'}</small>
                                        <div class="text-dark fw-bold">${not empty nombreUsuario ? nombreUsuario : 'Usuario'}</div>
                                    </div>
                                    <div class="logo-placeholder">${not empty nombreUsuario ? nombreUsuario.charAt(0) : 'U'}</div>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Perfil</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Configuración</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                <div class="container-fluid">
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <div class="card card-custom">
                        <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Lista de Clientes</h5>
                            <div>
                                <a href="clientes?action=nuevo" class="btn btn-custom">
                                    <i class="fas fa-plus me-2"></i>Nuevo Cliente
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Filtros y búsqueda -->
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <form action="clientes" method="get" class="search-form">
                                        <input type="hidden" name="action" value="lista">
                                        <div class="input-group">
                                            <input type="text" class="form-control" name="search" 
                                                   placeholder="Buscar por nombre, email o documento..." 
                                                   value="${param.search}">
                                            <button class="btn btn-outline-secondary" type="submit">
                                                <i class="fas fa-search"></i>
                                            </button>
                                            <c:if test="${not empty param.search}">
                                                <a href="clientes" class="btn btn-outline-danger">
                                                    <i class="fas fa-times"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </form>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" onchange="filterByType(this.value)">
                                        <option value="">Todos los tipos</option>
                                        <option value="Premium" ${param.tipo == 'Premium' ? 'selected' : ''}>Premium</option>
                                        <option value="Regular" ${param.tipo == 'Regular' ? 'selected' : ''}>Regular</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" onchange="filterByStatus(this.value)">
                                        <option value="">Todos los estados</option>
                                        <option value="Activo" ${param.estado == 'Activo' ? 'selected' : ''}>Activo</option>
                                        <option value="Inactivo" ${param.estado == 'Inactivo' ? 'selected' : ''}>Inactivo</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Tabla de clientes -->
                            <div class="table-responsive">
                                <table class="table table-hover table-striped">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Código</th>
                                            <th>Nombre Completo</th>
                                            <th>Email</th>
                                            <th>Teléfono</th>
                                            <th>Tipo</th>
                                            <th>Estado</th>
                                            <th>Fecha Registro</th>
                                            <th class="table-actions">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty clientes}">
                                                <c:forEach var="cliente" items="${clientes}">
                                                    <tr>
                                                        <td>
                                                            <strong>${cliente.codigo}</strong>
                                                        </td>
                                                        <td>
                                                            <div class="fw-bold">${cliente.nombre}</div>
                                                            <small class="text-muted">
                                                                <c:choose>
                                                                    <c:when test="${not empty cliente.tipo_documento and not empty cliente.numero_documento}">
                                                                        ${cliente.tipo_documento}: ${cliente.numero_documento}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Documento no especificado
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty cliente.email}">
                                                                <i class="fas fa-envelope me-1 text-muted"></i>
                                                                ${cliente.email}
                                                            </c:if>
                                                            <c:if test="${empty cliente.email}">
                                                                <span class="text-muted">No especificado</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty cliente.telefono}">
                                                                <i class="fas fa-phone me-1 text-muted"></i>
                                                                ${cliente.telefono}
                                                            </c:if>
                                                            <c:if test="${empty cliente.telefono}">
                                                                <span class="text-muted">No especificado</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${cliente.tipo == 'Premium'}">
                                                                    <span class="badge badge-premium">
                                                                        <i class="fas fa-crown me-1"></i>${cliente.tipo}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-regular">${cliente.tipo}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check-circle me-1"></i>${cliente.estado}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">${cliente.fecha_registro}</small>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <a href="clientes?action=detalle&id=${cliente.id}" 
                                                                   class="btn btn-outline-info" 
                                                                   title="Ver detalles">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="clientes?action=editar&id=${cliente.id}" 
                                                                   class="btn btn-outline-primary"
                                                                   title="Editar cliente">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <form action="clientes" method="post" style="display: inline;">
                                                                    <input type="hidden" name="action" value="eliminar">
                                                                    <input type="hidden" name="id" value="${cliente.id}">
                                                                    <button type="submit" 
                                                                            class="btn btn-outline-danger" 
                                                                            onclick="return confirm('¿Está seguro de eliminar al cliente ${cliente.nombre}? Esta acción no se puede deshacer.')"
                                                                            title="Eliminar cliente">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" class="text-center py-4">
                                                        <div class="text-muted">
                                                            <i class="fas fa-users fa-3x mb-3"></i>
                                                            <h5>No se encontraron clientes</h5>
                                                            <p>No hay clientes registrados en el sistema.</p>
                                                            <a href="clientes?action=nuevo" class="btn btn-custom">
                                                                <i class="fas fa-plus me-2"></i>Agregar Primer Cliente
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Información de resultados -->
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <div class="text-muted">
                                    Mostrando <strong>${empty clientes ? 0 : clientes.size()}</strong> cliente(s)
                                </div>
                                <!-- Paginación (puedes implementarla más adelante) -->
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item disabled">
                                            <a class="page-link" href="#">Anterior</a>
                                        </li>
                                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                        <li class="page-item">
                                            <a class="page-link" href="#">Siguiente</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
// Toggle sidebar simplificado
                                                                                document.getElementById('toggleSidebar').addEventListener('click', function () {
                                                                                    const sidebar = document.getElementById('sidebar');
                                                                                    const mainContent = document.getElementById('mainContent');
                                                                                    sidebar.classList.toggle('sidebar-collapsed');
                                                                                    mainContent.classList.toggle('main-content-expanded');
                                                                                });

                                                                                function filterByType(type) {
                                                                                    if (type) {
                                                                                        window.location.href = 'clientes?action=lista&tipo=' + type;
                                                                                    } else {
                                                                                        window.location.href = 'clientes';
                                                                                    }
                                                                                }

                                                                                function filterByStatus(status) {
                                                                                    if (status) {
                                                                                        window.location.href = 'clientes?action=lista&estado=' + status;
                                                                                    } else {
                                                                                        window.location.href = 'clientes';
                                                                                    }
                                                                                }

                                                                                // Función para buscar en tiempo real (opcional)
                                                                                function liveSearch() {
                                                                                    const input = document.querySelector('input[name="search"]');
                                                                                    const table = document.querySelector('table tbody');
                                                                                    const rows = table.getElementsByTagName('tr');

                                                                                    input.addEventListener('keyup', function () {
                                                                                        const filter = input.value.toLowerCase();

                                                                                        for (let i = 0; i < rows.length; i++) {
                                                                                            const cells = rows[i].getElementsByTagName('td');
                                                                                            let found = false;

                                                                                            for (let j = 0; j < cells.length; j++) {
                                                                                                const cellText = cells[j].textContent || cells[j].innerText;
                                                                                                if (cellText.toLowerCase().indexOf(filter) > -1) {
                                                                                                    found = true;
                                                                                                    break;
                                                                                                }
                                                                                            }

                                                                                            rows[i].style.display = found ? '' : 'none';
                                                                                        }
                                                                                    });
                                                                                }

                                                                                // Inicializar búsqueda en tiempo real si no hay búsqueda del servidor
            <c:if test="${empty param.search}">
                                                                                liveSearch();
            </c:if>
        </script>
    </body>
</html>