<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detalle de Venta | Sistema Comercial</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleVD.css">
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
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">
                            <i class="fas fa-file-invoice me-2"></i> Detalle de Venta
                        </h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/ventas" class="btn btn-outline-custom me-2">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Ventas
                            </a>
                            <button class="btn btn-custom" onclick="window.print()">
                                <i class="fas fa-print me-2"></i>Imprimir
                            </button>
                        </div>
                    </div>

                    <c:if test="${not empty venta}">
                        <div class="card card-custom">
                            <div class="card-header card-header-custom">
                                <h5 class="mb-0">Factura: ${venta.numeroFactura}</h5>
                                <span class="badge ${venta.estado == 'COMPLETADA' ? 'badge-completed' : venta.estado == 'PENDIENTE' ? 'badge-pending' : 'badge-cancelled'}">
                                    ${venta.estado}
                                </span>
                            </div>
                            <div class="card-body">
                                <!-- Información de la venta -->
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <h6 class="text-muted">Información del Cliente</h6>
                                        <div class="mb-2">
                                            <strong>Cliente:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty venta.cliente and not empty venta.cliente.nombre}">
                                                    ${venta.cliente.nombre}
                                                </c:when>
                                                <c:otherwise>
                                                    Cliente no disponible
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${not empty venta.cliente and not empty venta.cliente.correoElectronico}">
                                            <div class="mb-2">
                                                <strong>Email:</strong> ${venta.cliente.correoElectronico}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty venta.cliente and not empty venta.cliente.celular}">
                                            <div class="mb-2">
                                                <strong>Teléfono:</strong> ${venta.cliente.celular}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty venta.cliente and not empty venta.cliente.direccion}">
                                            <div class="mb-2">
                                                <strong>Dirección:</strong> ${venta.cliente.direccion}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="text-muted">Información de la Venta</h6>
                                        <div class="mb-2">
                                            <strong>Fecha:</strong> ${venta.fecha}
                                        </div>
                                        <div class="mb-2">
                                            <strong>Método de Pago:</strong> 
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
                                        </div>
                                        <div class="mb-2">
                                            <strong>Vendedor:</strong> Asesor Comercial
                                        </div>
                                        <c:if test="${not empty venta.fechaCreacion}">
                                            <div class="mb-2">
                                                <strong>Fecha de Registro:</strong> 
                                                ${venta.fechaCreacion.toLocalDate()} ${venta.fechaCreacion.toLocalTime()}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Detalles de productos -->
                                <h6 class="text-muted mb-3">Productos Vendidos</h6>
                                <div class="table-responsive mb-4">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Producto</th>
                                                <th class="text-center">Cantidad</th>
                                                <th class="text-end">Precio Unitario</th>
                                                <th class="text-end">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detalle" items="${venta.detalles}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:if test="${not empty detalle.producto and not empty detalle.producto.imagen}">
                                                                <img src="${pageContext.request.contextPath}/images/productos/${detalle.producto.imagen}" 
                                                                     alt="${detalle.producto.nombre}" class="sale-item-img me-3">
                                                            </c:if>
                                                            <div>
                                                                <div class="fw-bold">
                                                                    <c:choose>
                                                                        <c:when test="${not empty detalle.producto and not empty detalle.producto.nombre}">
                                                                            ${detalle.producto.nombre}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Producto no disponible
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <c:if test="${not empty detalle.producto and not empty detalle.producto.descripcion}">
                                                                    <small class="text-muted">${detalle.producto.descripcion}</small>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">${detalle.cantidad}</td>
                                                    <td class="text-end">
                                                        $<fmt:formatNumber value="${detalle.precioUnitario}" pattern="#,##0"/>
                                                    </td>
                                                    <td class="text-end">
                                                        $<fmt:formatNumber value="${detalle.total}" pattern="#,##0"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Resumen de totales -->
                                <div class="row justify-content-end">
                                    <div class="col-md-6">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Subtotal:</span>
                                                    <span>$<fmt:formatNumber value="${venta.subtotal}" pattern="#,##0"/></span>
                                                </div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Descuento:</span>
                                                    <span>$<fmt:formatNumber value="${venta.descuento}" pattern="#,##0"/></span>
                                                </div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>IVA (19%):</span>
                                                    <span>$<fmt:formatNumber value="${venta.iva}" pattern="#,##0"/></span>
                                                </div>
                                                <hr>
                                                <div class="d-flex justify-content-between fw-bold fs-5">
                                                    <span>Total:</span>
                                                    <span>$<fmt:formatNumber value="${venta.total}" pattern="#,##0"/></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Notas -->
                                <c:if test="${not empty venta.notas}">
                                    <div class="mt-4">
                                        <h6 class="text-muted">Notas</h6>
                                        <div class="border rounded p-3 bg-light">
                                            ${venta.notas}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${empty venta}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            No se encontró la venta solicitada.
                        </div>
                    </c:if>
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