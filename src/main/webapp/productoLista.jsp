<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    if (success == null) success = request.getParameter("success");
    if (error == null) error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lista de Productos | Sistema CV</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StylePL.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts - Roboto -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/clientes">
                            <i class="fas fa-users"></i> Clientes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/productos">
                            <i class="fas fa-box"></i> Productos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cotizaciones">
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
                            <h4 class="mb-0">Gestión de Productos</h4>
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
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1"><i class="fas fa-boxes me-2"></i> Lista de Productos</h2>
                            <p class="text-muted mb-0">Gestión completa del inventario de productos</p>
                        </div>
                        <div>
                            <button class="btn btn-outline-custom">
                                <i class="fas fa-file-export me-2"></i>Exportar
                            </button>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="card-title text-muted">Total Productos</h5>
                                            <h2 class="card-text text-primary">${not empty productos ? productos.size() : 0}</h2>
                                        </div>
                                        <div class="icon-circle bg-primary">
                                            <i class="fas fa-box text-white"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="card-title text-muted">Stock Bajo</h5>
                                            <h2 class="card-text text-warning">
                                                <c:set var="stockBajo" value="0" />
                                                <c:forEach var="producto" items="${productos}">
                                                    <c:if test="${producto.stock <= 10 && producto.stock > 0}">
                                                        <c:set var="stockBajo" value="${stockBajo + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${stockBajo}
                                            </h2>
                                        </div>
                                        <div class="icon-circle bg-warning">
                                            <i class="fas fa-exclamation-triangle text-white"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="card-title text-muted">Sin Stock</h5>
                                            <h2 class="card-text text-danger">
                                                <c:set var="sinStock" value="0" />
                                                <c:forEach var="producto" items="${productos}">
                                                    <c:if test="${producto.stock == 0}">
                                                        <c:set var="sinStock" value="${sinStock + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${sinStock}
                                            </h2>
                                        </div>
                                        <div class="icon-circle bg-danger">
                                            <i class="fas fa-times-circle text-white"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="card-title text-muted">Stock Óptimo</h5>
                                            <h2 class="card-text text-success">
                                                <c:set var="stockOptimo" value="0" />
                                                <c:forEach var="producto" items="${productos}">
                                                    <c:if test="${producto.stock > 20}">
                                                        <c:set var="stockOptimo" value="${stockOptimo + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${stockOptimo}
                                            </h2>
                                        </div>
                                        <div class="icon-circle bg-success">
                                            <i class="fas fa-check-circle text-white"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card card-custom mb-4">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0"><i class="fas fa-filter me-2"></i>Filtros y Búsqueda</h5>
                        </div>
                        <div class="card-body">
                            <form method="get" action="${pageContext.request.contextPath}/productos">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="input-group">
                                            <input type="text" name="busqueda" class="form-control" 
                                                   placeholder="Buscar por nombre, código o descripción..." 
                                                   value="${param.busqueda}">
                                            <button type="submit" class="btn btn-custom">
                                                <i class="fas fa-search me-1"></i>Buscar
                                            </button>
                                            <c:if test="${not empty param.busqueda}">
                                                <a href="${pageContext.request.contextPath}/productos" class="btn btn-outline-secondary">
                                                    <i class="fas fa-times"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="form-select" name="categoria" onchange="this.form.submit()">
                                            <option value="">Todas las categorías</option>
                                            <c:forEach var="cat" items="${categorias}">
                                                <option value="${cat.id}" 
                                                        ${param.categoria == cat.id ? 'selected' : ''}>
                                                    ${cat.nombre}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <a href="${pageContext.request.contextPath}/productos" class="btn btn-outline-secondary w-100">
                                            <i class="fas fa-refresh me-1"></i>Limpiar
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card card-custom">
                        <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>Productos 
                                    <c:if test="${not empty param.busqueda}">
                                        - Resultados para: "${param.busqueda}"
                                    </c:if>
                                    <c:if test="${not empty param.categoria}">
                                        - Categoría: 
                                        <c:forEach var="cat" items="${categorias}">
                                            <c:if test="${cat.id == param.categoria}">
                                                ${cat.nombre}
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </h5>
                            </div>
                            <div>
                                <span class="badge bg-primary fs-6">${not empty productos ? productos.size() : 0} productos</span>
                            </div>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty productos}">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped align-middle">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th width="50">#</th>
                                                    <th>Producto</th>
                                                    <th width="120">Código</th>
                                                    <th width="150">Categoría</th>
                                                    <th width="120">Precio</th>
                                                    <th width="120">Stock</th>
                                                    <th width="150">Ubicación</th>
                                                    <th width="150">Proveedor</th>
                                                    <th width="120">Estado</th>
                                                    <th width="100" class="text-center">Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="producto" items="${productos}" varStatus="status">
                                                    <c:set var="stockClass" value="" />
                                                    <c:set var="estado" value="" />
                                                    <c:set var="estadoBadge" value="" />
                                                    <c:choose>
                                                        <c:when test="${producto.stock == 0}">
                                                            <c:set var="stockClass" value="stock-low" />
                                                            <c:set var="estado" value="Sin Stock" />
                                                            <c:set var="estadoBadge" value="bg-danger" />
                                                        </c:when>
                                                        <c:when test="${producto.stock <= 10}">
                                                            <c:set var="stockClass" value="stock-low" />
                                                            <c:set var="estado" value="Stock Bajo" />
                                                            <c:set var="estadoBadge" value="bg-warning" />
                                                        </c:when>
                                                        <c:when test="${producto.stock <= 20}">
                                                            <c:set var="stockClass" value="stock-medium" />
                                                            <c:set var="estado" value="Stock Medio" />
                                                            <c:set var="estadoBadge" value="bg-info" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="stockClass" value="stock-high" />
                                                            <c:set var="estado" value="Stock Óptimo" />
                                                            <c:set var="estadoBadge" value="bg-success" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <tr>
                                                        <td class="fw-bold text-muted">${status.index + 1}</td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="${pageContext.request.contextPath}/images/productos/${not empty producto.imagen ? producto.imagen : 'default.jpg'}" 
                                                                     alt="${producto.nombre}" 
                                                                     class="product-img me-3"
                                                                     onerror="this.src='${pageContext.request.contextPath}/images/productos/default.jpg'">
                                                                <div>
                                                                    <h6 class="mb-1 fw-bold">${producto.nombre}</h6>
                                                                    <div class="text-muted small">
                                                                        <div>Color: ${not empty producto.color ? producto.color : 'N/A'}</div>
                                                                        <c:if test="${producto.rectificado}">
                                                                            <span class="badge bg-info me-1">Rectificado</span>
                                                                        </c:if>
                                                                        <c:if test="${not empty producto.acabado}">
                                                                            <span class="badge bg-secondary">${producto.acabado}</span>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-dark fs-6">${producto.codigo}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-category ceramica">
                                                                ${not empty producto.categoriaNombre ? producto.categoriaNombre : 'Sin categoría'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="fw-bold text-success">$${producto.precio}</div>
                                                            <small class="text-muted">M<sup>2</sup></small>
                                                        </td>
                                                        <td class="${stockClass} fw-bold">
                                                            ${producto.stock} und
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty producto.ubicacion}">
                                                                <span class="badge bg-light text-dark border">
                                                                    <i class="fas fa-map-marker-alt me-1 text-primary"></i>
                                                                    ${producto.ubicacion}
                                                                </span>
                                                            </c:if>
                                                            <c:if test="${empty producto.ubicacion}">
                                                                <span class="text-muted small">No asignada</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="fw-medium">${not empty producto.proveedorNombre ? producto.proveedorNombre : 'No asignado'}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${estadoBadge}">${estado}</span>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm" role="group">
                                                                <a href="${pageContext.request.contextPath}/productos?action=ver&id=${producto.id}" 
                                                                   class="btn btn-outline-primary" 
                                                                   title="Ver detalles">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                                        <h4 class="text-muted">No se encontraron productos</h4>
                                        <p class="text-muted mb-4">
                                            <c:choose>
                                                <c:when test="${not empty param.busqueda}">
                                                    No hay productos que coincidan con "${param.busqueda}"
                                                </c:when>
                                                <c:when test="${not empty param.categoria}">
                                                    No hay productos en esta categoría
                                                </c:when>
                                                <c:otherwise>
                                                    No hay productos registrados en el sistema
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            // Script para toggle sidebar
                                            document.getElementById('toggleSidebar').addEventListener('click', function () {
                                                const sidebar = document.getElementById('sidebar');
                                                const mainContent = document.getElementById('mainContent');

                                                sidebar.classList.toggle('d-none');
                                                sidebar.classList.toggle('d-md-block');
                                                mainContent.classList.toggle('expanded');
                                            });

                                            // Auto-cerrar alerts después de 5 segundos
                                            setTimeout(function () {
                                                const alerts = document.querySelectorAll('.alert');
                                                alerts.forEach(alert => {
                                                    const bsAlert = new bootstrap.Alert(alert);
                                                    bsAlert.close();
                                                });
                                            }, 5000);

                                            // Inicializar tooltips
                                            document.addEventListener('DOMContentLoaded', function () {
                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                                });
                                            });
        </script>
    </body>
</html>