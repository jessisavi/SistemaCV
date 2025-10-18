<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ventas | Sistema Comercial</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleVL.css">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/cotizaciones">
                            <i class="fas fa-file-invoice"></i> Cotizaciones
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/ventas">
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
                            <h4 class="mb-0">Gestión de Ventas</h4>
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
                    <!-- Mensajes -->
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

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0"><i class="fas fa-shopping-cart me-2"></i> Gestión de Ventas</h2>
                        <a href="${pageContext.request.contextPath}/ventas/crear" class="btn btn-custom">
                            <i class="fas fa-plus me-2"></i>Nueva Venta
                        </a>
                    </div>

                    <!-- Estadísticas de Ventas -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Ventas Hoy</h5>
                                    <h2 class="card-text">
                                        $<fmt:formatNumber value="${not empty ventasHoy ? ventasHoy : 0}" pattern="#,##0"/>
                                    </h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> En el día de hoy</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Ventas Mensuales</h5>
                                    <h2 class="card-text">
                                        $<fmt:formatNumber value="${not empty ventasMensuales ? ventasMensuales : 0}" pattern="#,##0"/>
                                    </h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> Este mes</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Ventas Anuales</h5>
                                    <h2 class="card-text">
                                        $<fmt:formatNumber value="${not empty ventasAnuales ? ventasAnuales : 0}" pattern="#,##0"/>
                                    </h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> Este año</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Meta Mensual</h5>
                                    <div class="d-flex justify-content-between mb-2">
                                        <h3>
                                        <span>$<fmt:formatNumber value="${not empty metaMensual ? metaMensual : 0}" pattern="#,##0"/></span>
                                        </h3>
                                        <span>${not empty porcentajeMeta ? porcentajeMeta : 0}%</span>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar" role="progressbar" 
                                             style="width: ${not empty porcentajeMeta ? porcentajeMeta : 0}%" 
                                             aria-valuenow="${not empty porcentajeMeta ? porcentajeMeta : 0}" 
                                             aria-valuemin="0" aria-valuemax="100">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Embudo de Ventas -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Resumen de Ventas</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row text-center">
                                        <div class="col-md-3">
                                            <div class="funnel-step">
                                                <div class="funnel-number">${not empty ventas ? ventas.size() : 0}</div>
                                                <h6>Total Ventas</h6>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="funnel-step">
                                                <div class="funnel-number">
                                                    <c:set var="ventasCompletadas" value="0" />
                                                    <c:if test="${not empty ventas}">
                                                        <c:forEach var="venta" items="${ventas}">
                                                            <c:if test="${venta.estado == 'COMPLETADA'}">
                                                                <c:set var="ventasCompletadas" value="${ventasCompletadas + 1}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    ${ventasCompletadas}
                                                </div>
                                                <h6>Completadas</h6>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="funnel-step">
                                                <div class="funnel-number">
                                                    <c:set var="ventasPendientes" value="0" />
                                                    <c:if test="${not empty ventas}">
                                                        <c:forEach var="venta" items="${ventas}">
                                                            <c:if test="${venta.estado == 'PENDIENTE'}">
                                                                <c:set var="ventasPendientes" value="${ventasPendientes + 1}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    ${ventasPendientes}
                                                </div>
                                                <h6>Pendientes</h6>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="funnel-step">
                                                <div class="funnel-number">
                                                    <c:set var="ventasCanceladas" value="0" />
                                                    <c:if test="${not empty ventas}">
                                                        <c:forEach var="venta" items="${ventas}">
                                                            <c:if test="${venta.estado == 'CANCELADA'}">
                                                                <c:set var="ventasCanceladas" value="${ventasCanceladas + 1}" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    ${ventasCanceladas}
                                                </div>
                                                <h6>Canceladas</h6>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <!-- Ventas Recientes -->
                            <div class="card card-custom mb-4">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Ventas Recientes</h5>
                                    <div class="d-flex">
                                        <form method="get" action="${pageContext.request.contextPath}/ventas" class="d-flex me-3">
                                            <div class="input-group" style="width: 250px;">
                                                <input type="text" class="form-control" name="busqueda" placeholder="Buscar ventas..." value="${busqueda}">
                                                <button class="btn btn-outline-secondary" type="submit">
                                                    <i class="fas fa-search"></i>
                                                </button>
                                            </div>
                                        </form>
                                        <form method="get" action="${pageContext.request.contextPath}/ventas" class="d-flex">
                                            <select class="form-select" name="filtroEstado" onchange="this.form.submit()" style="width: 150px;">
                                                <option value="Todos" ${filtroEstado == 'Todos' || empty filtroEstado ? 'selected' : ''}>Todos</option>
                                                <option value="COMPLETADA" ${filtroEstado == 'COMPLETADA' ? 'selected' : ''}>Completadas</option>
                                                <option value="PENDIENTE" ${filtroEstado == 'PENDIENTE' ? 'selected' : ''}>Pendientes</option>
                                                <option value="CANCELADA" ${filtroEstado == 'CANCELADA' ? 'selected' : ''}>Canceladas</option>
                                            </select>
                                        </form>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>N° Factura</th>
                                                    <th>Cliente</th>
                                                    <th>Fecha</th>
                                                    <th>Método Pago</th>
                                                    <th>Total</th>
                                                    <th>Estado</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${not empty ventas}">
                                                    <c:forEach var="venta" items="${ventas}">
                                                        <tr>
                                                            <td>${venta.numeroFactura}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty venta.cliente and not empty venta.cliente.nombre}">
                                                                        ${venta.cliente.nombre}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Cliente no disponible
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                ${venta.fecha}
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${venta.metodoPago == 'EFECTIVO'}">
                                                                        <span class="badge bg-success">Efectivo</span>
                                                                    </c:when>
                                                                    <c:when test="${venta.metodoPago == 'TARJETA_CREDITO'}">
                                                                        <span class="badge bg-primary">Tarjeta</span>
                                                                    </c:when>
                                                                    <c:when test="${venta.metodoPago == 'TRANSFERENCIA'}">
                                                                        <span class="badge bg-info">Transferencia</span>
                                                                    </c:when>
                                                                    <c:when test="${venta.metodoPago == 'CHEQUE'}">
                                                                        <span class="badge bg-warning">Cheque</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${venta.metodoPago}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                $<fmt:formatNumber value="${not empty venta.total ? venta.total : 0}" pattern="#,##0"/>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${venta.estado == 'COMPLETADA'}">
                                                                        <span class="badge badge-completed">Completada</span>
                                                                    </c:when>
                                                                    <c:when test="${venta.estado == 'PENDIENTE'}">
                                                                        <span class="badge badge-pending">Pendiente</span>
                                                                    </c:when>
                                                                    <c:when test="${venta.estado == 'CANCELADA'}">
                                                                        <span class="badge badge-cancelled">Cancelada</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${venta.estado}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group btn-group-sm" role="group">
                                                                    <a href="${pageContext.request.contextPath}/ventas/detalle?id=${venta.idventa}" 
                                                                       class="btn btn-outline-primary" title="Ver detalles">
                                                                        <i class="fas fa-eye"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/ventas/editar?id=${venta.idventa}" 
                                                                       class="btn btn-outline-secondary" title="Editar">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>

                                                                    <button class="btn btn-sm btn-outline-secondary ms-1" title="Imprimir">
                                                                        <i class="fas fa-print"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:if>
                                                <c:if test="${empty ventas}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-4">
                                                            <i class="fas fa-shopping-cart fa-2x mb-2"></i><br>
                                                            No se encontraron ventas
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Productos Más Vendidos -->
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Productos Más Vendidos</h5>
                                </div>
                                <div class="card-body">
                                    <div class="list-group">
                                        <c:if test="${not empty productosMasVendidos}">
                                            <c:forEach var="producto" items="${productosMasVendidos}">
                                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                                    <div class="d-flex align-items-center">
                                                        <c:if test="${not empty producto.imagen}">
                                                            <img src="${pageContext.request.contextPath}/images/productos/${producto.imagen}" 
                                                                 alt="${producto.nombre}" class="sale-item-img me-3">
                                                        </c:if>
                                                        <span>${producto.nombre}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty productosMasVendidos}">
                                            <div class="list-group-item text-center text-muted">
                                                <i class="fas fa-box fa-2x mb-2"></i><br>
                                                No hay datos de productos vendidos
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
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
        </script>
    </body>
</html>