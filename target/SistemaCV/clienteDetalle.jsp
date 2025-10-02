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
        <title>Detalle de Cliente | Sistema Empresarial</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCD.css">
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar d-none d-md-block">
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
            <div class="main-content flex-grow-1">
                <nav class="navbar navbar-custom mb-4">
                    <div class="container-fluid">
                        <div class="d-flex align-items-center">
                            <button class="toggle-sidebar me-3">
                                <i class="fas fa-bars"></i>
                            </button>
                            <a href="clientes" class="btn btn-outline-secondary me-2">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Clientes
                            </a>
                            <h4 class="mb-0">Detalle del Cliente</h4>
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="me-3">${sessionScope.nombreUsuario} (${sessionScope.rolUsuario})</span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid">
                    <c:if test="${empty cliente}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Cliente no encontrado
                        </div>
                        <div class="text-center mt-4">
                            <a href="clientes" class="btn btn-custom">
                                <i class="fas fa-arrow-left me-2"></i>Volver a la lista de clientes
                            </a>
                        </div>
                    </c:if>

                    <c:if test="${not empty cliente}">
                        <div class="row">
                            <div class="col-md-4">
                                <!-- Tarjeta de perfil del cliente -->
                                <div class="card card-custom">
                                    <div class="card-body text-center">
                                        <div class="customer-avatar-lg">
                                            ${cliente.nombre.substring(0,1)}${cliente.apellido.substring(0,1)}
                                        </div>
                                        <h3 class="customer-name">${cliente.nombre} ${cliente.apellido}</h3>
                                        <div class="customer-id">ID: ${cliente.codigo}</div>
                                        <span class="customer-status status-active">
                                            <i class="fas fa-circle me-1"></i>Cliente ${cliente.estado}
                                        </span>
                                        <div class="mt-3">
                                            <a href="clientes?action=editar&id=${cliente.id}" class="btn btn-custom me-2">
                                                <i class="fas fa-edit me-1"></i>Editar
                                            </a>
                                            <c:if test="${not empty cliente.email}">
                                                <a href="mailto:${cliente.email}" class="btn btn-outline-custom">
                                                    <i class="fas fa-envelope me-1"></i>Contactar
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="px-4 pb-4">
                                        <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Información del Cliente</h5>

                                        <div class="info-item">
                                            <div class="info-label">Tipo de Cliente</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${cliente.tipo_cliente == 'Premium'}">
                                                        <span class="badge badge-premium">
                                                            <i class="fas fa-crown me-1"></i>${cliente.tipo_cliente}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-regular">${cliente.tipo_cliente}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Correo Electrónico</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty cliente.email}">
                                                        <i class="fas fa-envelope me-1 text-muted"></i>
                                                        <a href="mailto:${cliente.email}">${cliente.email}</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Teléfono/Celular</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty cliente.telefono}">
                                                        <i class="fas fa-phone me-1 text-muted"></i>
                                                        <a href="tel:${cliente.telefono}">${cliente.telefono}</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Documento de Identidad</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty cliente.tipo_documento && not empty cliente.numero_documento}">
                                                        ${cliente.tipo_documento} ${cliente.numero_documento}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificado</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Fecha de Registro</div>
                                            <div class="info-value">
                                                <i class="fas fa-calendar me-1 text-muted"></i>
                                                ${cliente.fecha_registro}
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Dirección</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty cliente.direccion}">
                                                        <i class="fas fa-map-marker-alt me-1 text-muted"></i>
                                                        ${cliente.direccion}
                                                        <c:if test="${not empty cliente.ciudad}">
                                                            <br><small class="text-muted">${cliente.ciudad}</small>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No especificada</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <c:if test="${not empty cliente.idempleado}">
                                            <div class="info-item">
                                                <div class="info-label">Empleado Asignado</div>
                                                <div class="info-value">
                                                    <i class="fas fa-user-tie me-1 text-muted"></i>
                                                    ID: ${cliente.idempleado}
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Tarjeta de estadísticas -->
                                <div class="card card-custom mt-4">
                                    <div class="card-header card-header-custom">
                                        <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Estadísticas</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="info-item">
                                            <div class="info-label">Total Compras</div>
                                            <div class="info-value text-success">
                                                <i class="fas fa-dollar-sign me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty compras && compras.size() > 0}">
                                                        <!-- Aquí puedes calcular el total real cuando tengas datos de compras -->
                                                        $0
                                                    </c:when>
                                                    <c:otherwise>
                                                        $0
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Pedidos Realizados</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty compras}">
                                                        ${compras.size()}
                                                    </c:when>
                                                    <c:otherwise>
                                                        0
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Última Actividad</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${not empty cliente.fecha_registro}">
                                                        ${cliente.fecha_registro}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Sin actividad</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="info-item">
                                            <div class="info-label">Estado</div>
                                            <div class="info-value">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i>${cliente.estado}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-8">
                                <!-- Actividad reciente -->
                                <div class="card card-custom">
                                    <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0"><i class="fas fa-clock me-2"></i>Actividad Reciente</h5>
                                        <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-secondary active">Todos</button>
                                            <button class="btn btn-sm btn-outline-secondary">Compras</button>
                                            <button class="btn btn-sm btn-outline-secondary">Cotizaciones</button>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty compras && compras.size() > 0}">
                                                <div class="timeline">
                                                    <c:forEach var="compra" items="${compras}" varStatus="status">
                                                        <div class="timeline-item">
                                                            <div class="timeline-dot">
                                                                <i class="fas fa-shopping-cart"></i>
                                                            </div>
                                                            <div class="timeline-date">${compra.fecha}</div>
                                                            <h6>Pedido realizado - ${compra.pedido}</h6>
                                                            <p>${compra.productos} productos - Total: ${compra.total}</p>
                                                            <span class="badge bg-success">${compra.estado}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4">
                                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                                                    <h6 class="text-muted">No hay actividad reciente</h6>
                                                    <p class="text-muted">Este cliente no tiene registros de actividad.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Historial de compras -->
                                <div class="card card-custom mt-4">
                                    <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                        <h5 class="mb-0"><i class="fas fa-history me-2"></i>Historial</h5>
                                        <div>
                                            <select class="form-select form-select-sm" style="width: 150px;">
                                                <option>Últimos 3 meses</option>
                                                <option>Últimos 6 meses</option>
                                                <option>Este año</option>
                                                <option>Todos</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty compras && compras.size() > 0}">
                                                <div class="table-responsive">
                                                    <table class="table table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th>Pedido</th>
                                                                <th>Fecha</th>
                                                                <th>Productos</th>
                                                                <th>Total</th>
                                                                <th>Estado</th>
                                                                <th>Acciones</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="compra" items="${compras}">
                                                                <tr>
                                                                    <td><strong>${compra.pedido}</strong></td>
                                                                    <td>${compra.fecha}</td>
                                                                    <td>${compra.productos}</td>
                                                                    <td class="fw-bold text-success">${compra.total}</td>
                                                                    <td>
                                                                        <span class="badge bg-success">
                                                                            <i class="fas fa-check-circle me-1"></i>${compra.estado}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <button class="btn btn-sm btn-outline-secondary" title="Ver detalle">
                                                                            <i class="fas fa-eye"></i>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4">
                                                    <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                                                    <h6 class="text-muted">No hay historial disponible</h6>
                                                    <p class="text-muted">Este cliente no tiene registros de compras.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toggleSidebar = document.querySelector('.toggle-sidebar');
                const sidebar = document.querySelector('.sidebar');
                const mainContent = document.querySelector('.main-content');

                if (toggleSidebar) {
                    toggleSidebar.addEventListener('click', function () {
                        sidebar.classList.toggle('d-none');
                        sidebar.classList.toggle('d-md-block');
                    });
                }

                // Activar/desactivar filtros de actividad
                const filterButtons = document.querySelectorAll('.btn-group .btn');
                filterButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        filterButtons.forEach(btn => btn.classList.remove('active'));
                        this.classList.add('active');
                    });
                });
            });
        </script>
    </body>
</html>