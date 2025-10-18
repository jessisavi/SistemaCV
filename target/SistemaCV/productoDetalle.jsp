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
        <title>Detalle del Producto | Sistema CV</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StylePD.css">
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
                            <h4 class="mb-0">Detalle del Producto</h4>
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
                            <h2 class="mb-1"><i class="fas fa-box me-2"></i> Detalle del Producto</h2>
                            <p class="text-muted mb-0">Información completa del producto seleccionado</p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/productos" class="btn btn-outline-custom">
                                <i class="fas fa-arrow-left me-2"></i> Volver a Productos
                            </a>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty producto}">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="mb-0">
                                            <i class="fas fa-box me-2"></i>${producto.nombre}
                                        </h4>
                                    </div>
                                    <div>
                                        <span class="badge bg-dark fs-6">${producto.codigo}</span>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4 text-center mb-4">
                                            <img src="${pageContext.request.contextPath}/images/productos/${not empty producto.imagen ? producto.imagen : 'default.jpg'}" 
                                                 alt="${producto.nombre}" 
                                                 class="img-fluid rounded"
                                                 style="max-height: 300px;"
                                                 onerror="this.src='${pageContext.request.contextPath}/images/productos/default.jpg'">
                                        </div>

                                        <div class="col-md-8">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h5 class="text-primary mb-3">Información General</h5>
                                                    <table class="table table-borderless">
                                                        <tr>
                                                            <td class="fw-bold" style="width: 40%;">Nombre:</td>
                                                            <td>${producto.nombre}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Código:</td>
                                                            <td><span class="badge bg-secondary">${producto.codigo}</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Descripción:</td>
                                                            <td>${not empty producto.descripcion ? producto.descripcion : 'No disponible'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Color:</td>
                                                            <td>${not empty producto.color ? producto.color : 'No especificado'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Categoría:</td>
                                                            <td>
                                                                <span class="badge badge-category ceramica">
                                                                    ${not empty producto.categoriaNombre ? producto.categoriaNombre : 'Sin categoría'}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>

                                                <div class="col-md-6">
                                                    <h5 class="text-primary mb-3">Especificaciones</h5>
                                                    <table class="table table-borderless">
                                                        <tr>
                                                            <td class="fw-bold" style="width: 40%;">Acabado:</td>
                                                            <td>${not empty producto.acabado ? producto.acabado : 'No especificado'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Rectificado:</td>
                                                            <td>
                                                                <span class="badge ${producto.rectificado ? 'bg-success' : 'bg-secondary'}">
                                                                    ${producto.rectificado ? 'Sí' : 'No'}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Tráfico:</td>
                                                            <td>${not empty producto.trafico ? producto.trafico : 'No especificado'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold">Proveedor:</td>
                                                            <td>${not empty producto.proveedorNombre ? producto.proveedorNombre : 'No asignado'}</td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-12">
                                                    <h5 class="text-primary mb-3">Información de Inventario</h5>
                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="card bg-light">
                                                                <div class="card-body text-center">
                                                                    <h6 class="card-title text-muted">Precio</h6>
                                                                    <h3 class="text-success">$${producto.precio}</h3>
                                                                    <small class="text-muted">por M<sup>2</sup></small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="card bg-light">
                                                                <div class="card-body text-center">
                                                                    <h6 class="card-title text-muted">Stock Actual</h6>
                                                                    <h3 class="${producto.stock <= 10 ? 'text-danger' : producto.stock <= 20 ? 'text-warning' : 'text-success'}">
                                                                        ${producto.stock}
                                                                    </h3>
                                                                    <small class="text-muted">unidades</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="card bg-light">
                                                                <div class="card-body text-center">
                                                                    <h6 class="card-title text-muted">Ubicación</h6>
                                                                    <h5 class="text-primary">
                                                                        ${not empty producto.ubicacion ? producto.ubicacion : 'No asignada'}
                                                                    </h5>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-12">
                                                    <h5 class="text-primary mb-3">Estado del Stock</h5>
                                                    <div class="d-flex justify-content-center">
                                                        <c:choose>
                                                            <c:when test="${producto.stock == 0}">
                                                                <span class="badge bg-danger fs-5 p-3">Sin Stock</span>
                                                            </c:when>
                                                            <c:when test="${producto.stock <= 10}">
                                                                <span class="badge bg-warning fs-5 p-3">Stock Bajo</span>
                                                            </c:when>
                                                            <c:when test="${producto.stock <= 20}">
                                                                <span class="badge bg-info fs-5 p-3">Stock Medio</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success fs-5 p-3">Stock Óptimo</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-12">
                                                    <h5 class="text-primary mb-3">Información del Sistema</h5>
                                                    <div class="d-flex justify-content-between text-muted">
                                                        <div>
                                                            <small><strong>Fecha de Creación:</strong> 
                                                                ${not empty producto.fechaCreacion ? producto.fechaCreacion : 'No disponible'}
                                                            </small>
                                                        </div>
                                                        <div>
                                                            <small><strong>Última Actualización:</strong> 
                                                                ${not empty producto.fechaActualizacion ? producto.fechaActualizacion : 'No disponible'}
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning text-center">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No se pudo cargar la información del producto.
                                <a href="${pageContext.request.contextPath}/productos" class="alert-link ms-2">
                                    Volver a la lista de productos
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
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