<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cotizaciones | Sistema de Ventas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCOT.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar" id="sidebar">
                <div style="text-align: center;">
                    <img src="${pageContext.request.contextPath}/images/StylishHome.jpg" alt="Imagen corporativa" style="height: 14rem;">
                </div>
                <ul class="nav flex-column px-3">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/clientes">
                            <i class="fas fa-users"></i> Clientes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/productos">
                            <i class="fas fa-box"></i> Productos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/cotizaciones">
                            <i class="fas fa-file-invoice"></i> Cotizaciones
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ventas">
                            <i class="fas fa-file-invoice"></i> Ventas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/informes">
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
                <nav class="navbar navbar-custom mb-4">
                    <div class="container-fluid">
                        <div class="d-flex align-items-center">
                            <button class="toggle-sidebar me-3" id="toggleSidebar">
                                <i class="fas fa-bars"></i>
                            </button>
                            <h4 class="mb-0">Stylish Home</h4>
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
                    <c:if test="${not empty mensaje}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${mensaje}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Información de debug (temporal) -->
                    <c:if test="${empty cotizaciones}">
                        <div class="alert alert-warning">
                            <strong>Info:</strong> No se encontraron cotizaciones en la base de datos.
                            <br><small>Total de cotizaciones: 0</small>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0"><i class="fas fa-file-invoice-dollar me-2"></i> Gestión de Cotizaciones</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/cotizaciones?action=nuevo" class="btn btn-custom me-2">
                                <i class="fas fa-plus me-2"></i>Nueva Cotización
                            </a>
                            <button class="btn btn-outline-custom">
                                <i class="fas fa-file-export me-2"></i>Exportar
                            </button>
                        </div>
                    </div>

                    <!-- Estadísticas -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Cotizaciones Hoy</h5>
                                    <h2 class="card-text">${cotizacionesHoy}</h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> En el día de hoy</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Pendientes</h5>
                                    <h2 class="card-text">${pendientes}</h2>
                                    <p class="card-text text-warning small"><i class="fas fa-clock me-1"></i> Requieren atención</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Aprobadas</h5>
                                    <h2 class="card-text">${aprobadas}</h2>
                                    <p class="card-text text-success small"><i class="fas fa-check-circle me-1"></i> Listas para Pedido</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Valor Total</h5>
                                    <h2 class="card-text">$<fmt:formatNumber value="${valorTotal}" pattern="#,##0"/></h2>
                                    <p class="card-text text-primary small"><i class="fas fa-dollar-sign me-1"></i> Potencial de venta</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Lista de Cotizaciones -->
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">Listado de Cotizaciones</h5>
                            <div class="d-flex">
                                <form method="get" action="" class="d-flex me-3">
                                    <div class="input-group" style="width: 250px;">
                                        <input type="text" class="form-control" name="busqueda" placeholder="Buscar cotizaciones..." value="${busqueda}">
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                        <c:if test="${not empty busqueda}">
                                            <a href="${pageContext.request.contextPath}/cotizaciones" class="btn btn-outline-danger">
                                                <i class="fas fa-times"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <form method="get" action="" class="d-flex">
                                    <select class="form-select" name="filtroEstado" onchange="this.form.submit()" style="width: 150px;">
                                        <option value="Todas" ${filtroEstado == 'Todas' || empty filtroEstado ? 'selected' : ''}>Todas</option>
                                        <option value="PENDIENTE" ${filtroEstado == 'PENDIENTE' ? 'selected' : ''}>Pendientes</option>
                                        <option value="APROBADA" ${filtroEstado == 'APROBADA' ? 'selected' : ''}>Aprobadas</option>
                                        <option value="RECHAZADA" ${filtroEstado == 'RECHAZADA' ? 'selected' : ''}>Rechazadas</option>
                                        <option value="VENCIDA" ${filtroEstado == 'VENCIDA' ? 'selected' : ''}>Vencidas</option>
                                    </select>
                                    <c:if test="${not empty filtroEstado && filtroEstado != 'Todas'}">
                                        <a href="${pageContext.request.contextPath}/cotizaciones" class="btn btn-outline-danger ms-2">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </c:if>
                                </form>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>N° Cotización</th>
                                            <th>Cliente</th>
                                            <th>Fecha</th>
                                            <th>Válido hasta</th>
                                            <th>Total</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cotizacion" items="${cotizaciones}">
                                            <tr>
                                                <td><strong>${cotizacion.numeroCotizacion}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty cotizacion.cliente}">
                                                            ${cotizacion.cliente.nombre} ${cotizacion.cliente.apellido}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Cliente no disponible</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty cotizacion.fecha}">
                                                        ${cotizacion.fecha}
                                                    </c:if>
                                                    <c:if test="${empty cotizacion.fecha}">
                                                        <span class="text-muted">N/A</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty cotizacion.validoHasta}">
                                                        ${cotizacion.validoHasta}
                                                    </c:if>
                                                    <c:if test="${empty cotizacion.validoHasta}">
                                                        <span class="text-muted">N/A</span>
                                                    </c:if>
                                                </td>
                                                <td><strong>$<fmt:formatNumber value="${cotizacion.total}" pattern="#,##0"/></strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cotizacion.estado == 'PENDIENTE'}">
                                                            <span class="badge bg-warning">Pendiente</span>
                                                        </c:when>
                                                        <c:when test="${cotizacion.estado == 'APROBADA'}">
                                                            <span class="badge bg-success">Aprobada</span>
                                                        </c:when>
                                                        <c:when test="${cotizacion.estado == 'RECHAZADA'}">
                                                            <span class="badge bg-danger">Rechazada</span>
                                                        </c:when>
                                                        <c:when test="${cotizacion.estado == 'VENCIDA'}">
                                                            <span class="badge bg-secondary">Vencida</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${cotizacion.estado}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm" role="group">
                                                        <a href="${pageContext.request.contextPath}/cotizaciones?action=ver&id=${cotizacion.idcotizacion}" 
                                                           class="btn btn-outline-primary" title="Ver detalles">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/cotizaciones?action=editar&id=${cotizacion.idcotizacion}" 
                                                           class="btn btn-outline-secondary" title="Editar">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${cotizacion.estado == 'APROBADA'}">
                                                            <button class="btn btn-outline-success" title="Generar pedido">
                                                                <i class="fas fa-file-invoice"></i>
                                                            </button>
                                                        </c:if>
                                                        <c:if test="${cotizacion.estado != 'APROBADA' && cotizacion.estado != 'RECHAZADA'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/cotizaciones/estado" 
                                                                  style="display: inline;" onsubmit="return confirm('¿Está seguro de aprobar esta cotización?')">
                                                                <input type="hidden" name="id" value="${cotizacion.idcotizacion}">
                                                                <input type="hidden" name="estado" value="APROBADA">
                                                                <button type="submit" class="btn btn-outline-success" title="Aprobar">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty cotizaciones}">
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-5">
                                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                                    <h5>No se encontraron cotizaciones</h5>
                                                    <p class="mb-0">No hay cotizaciones registradas en el sistema</p>
                                                    <a href="${pageContext.request.contextPath}/cotizaciones/crear" class="btn btn-custom mt-3">
                                                        <i class="fas fa-plus me-2"></i>Crear primera cotización
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                      document.getElementById('toggleSidebar').addEventListener('click', function () {
                                                                          const sidebar = document.getElementById('sidebar');
                                                                          const mainContent = document.getElementById('mainContent');

                                                                          sidebar.classList.toggle('sidebar-collapsed');
                                                                          mainContent.classList.toggle('main-content-expanded');
                                                                      });

                                                                      // AGREGAR: Auto-cerrar alerts después de 5 segundos
                                                                      setTimeout(function () {
                                                                          const alerts = document.querySelectorAll('.alert');
                                                                          alerts.forEach(alert => {
                                                                              const bsAlert = new bootstrap.Alert(alert);
                                                                              bsAlert.close();
                                                                          });
                                                                      }, 5000);
        </script>
    </body>
</html>