<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
        <title>Detalle de Cotización | Sistema CV</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCOTDET.css">
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
                            <h2 class="mb-1"><i class="fas fa-file-invoice-dollar me-2"></i> Detalle de Cotización</h2>
                            <p class="text-muted mb-0">Información completa de la cotización seleccionada</p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/cotizaciones" class="btn btn-outline-custom me-2">
                                <i class="fas fa-arrow-left me-2"></i> Volver a Cotizaciones
                            </a>
                            <a href="${pageContext.request.contextPath}/cotizaciones?action=editar&id=${cotizacion.idcotizacion}"  class="btn btn-custom me-2">
                                <i class="fas fa-edit me-2"></i> Editar
                            </a>
                            <button class="btn btn-outline-custom">
                                <i class="fas fa-print me-2"></i> Imprimir
                            </button>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty cotizacion}">
                            <div class="card card-custom mb-4">
                                <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="mb-0">
                                            <i class="fas fa-file-invoice me-2"></i>${cotizacion.numeroCotizacion}
                                        </h4>
                                        <p class="mb-0 text-light">${cotizacion.proyecto}</p>
                                    </div>
                                    <div>
                                        <span class="badge
                                              <c:choose>
                                                  <c:when test="${cotizacion.estado == 'PENDIENTE'}">bg-warning</c:when>
                                                  <c:when test="${cotizacion.estado == 'APROBADA'}">bg-success</c:when>
                                                  <c:when test="${cotizacion.estado == 'RECHAZADA'}">bg-danger</c:when>
                                                  <c:when test="${cotizacion.estado == 'VENCIDA'}">bg-secondary</c:when>
                                                  <c:otherwise>bg-info</c:otherwise>
                                              </c:choose>
                                              fs-6 p-2">
                                            ${cotizacion.estado}
                                        </span>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <!-- Información General -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h5 class="text-primary mb-3"><i class="fas fa-info-circle me-2"></i>Información General</h5>
                                            <table class="table table-borderless">
                                                <tr>
                                                    <td class="fw-bold" style="width: 40%;">Número:</td>
                                                    <td><strong>${cotizacion.numeroCotizacion}</strong></td>
                                                </tr>
                                                <tr>
                                                    <td class="fw-bold">Cliente:</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cotizacion.cliente}">
                                                                ${cotizacion.cliente.nombre} ${cotizacion.cliente.apellido}
                                                                <c:if test="${not empty cotizacion.cliente.correoElectronico}">
                                                                    <br><small class="text-muted">${cotizacion.cliente.correoElectronico}</small>
                                                                </c:if>
                                                                <c:if test="${not empty cotizacion.cliente.celular}">
                                                                    <br><small class="text-muted">${cotizacion.cliente.celular}</small>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Cliente no disponible</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="fw-bold">Fecha:</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cotizacion.fecha}">
                                                                ${cotizacion.fecha}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="fw-bold">Válido hasta:</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty cotizacion.validoHasta}">
                                                                ${cotizacion.validoHasta}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="text-primary mb-3"><i class="fas fa-dollar-sign me-2"></i>Resumen Financiero</h5>
                                            <table class="table table-borderless">
                                                <tr>
                                                    <td class="fw-bold" style="width: 40%;">Subtotal:</td>
                                                    <td class="text-end">$<fmt:formatNumber value="${cotizacion.subtotal}" pattern="#,##0"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="fw-bold">Descuento:</td>
                                                    <td class="text-end text-danger">-$ <fmt:formatNumber value="${cotizacion.descuento}" pattern="#,##0"/></td>
                                                </tr>
                                                <tr>
                                                    <td class="fw-bold">IVA (19%):</td>
                                                    <td class="text-end">$<fmt:formatNumber value="${cotizacion.iva}" pattern="#,##0"/></td>
                                                </tr>
                                                <tr class="border-top">
                                                    <td class="fw-bold fs-5">Total:</td>
                                                    <td class="text-end fs-5 text-success fw-bold">
                                                        $<fmt:formatNumber value="${cotizacion.total}" pattern="#,##0"/>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Detalles de Productos -->
                                    <div class="row mb-4">
                                        <div class="col-12">
                                            <h5 class="text-primary mb-3"><i class="fas fa-list me-2"></i>Productos Cotizados</h5>
                                            <div class="table-responsive">
                                                <table class="table table-striped">
                                                    <thead class="table-dark">
                                                        <tr>
                                                            <th>Producto</th>
                                                            <th class="text-center">Cantidad</th>
                                                            <th class="text-end">Precio Unitario</th>
                                                            <th class="text-end">Descuento</th>
                                                            <th class="text-end">Total</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="detalle" items="${cotizacion.detalles}">
                                                            <tr>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty detalle.producto}">
                                                                            <strong>${detalle.producto.nombre}</strong>
                                                                            <c:if test="${not empty detalle.producto.descripcion}">
                                                                                <br><small class="text-muted">${detalle.producto.descripcion}</small>
                                                                            </c:if>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">Producto no disponible</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">${detalle.cantidad}</td>
                                                                <td class="text-end">$<fmt:formatNumber value="${detalle.precioUnitario}" pattern="#,##0"/></td>
                                                                <td class="text-end text-danger">
                                                                    <c:choose>
                                                                        <c:when test="${not empty detalle.descuentoMonto && detalle.descuentoMonto > 0}">
                                                                            - $<fmt:formatNumber value="${detalle.descuentoMonto}" pattern="#,##0"/>
                                                                        </c:when>
                                                                        <c:when test="${not empty detalle.descuentoPorcentaje && detalle.descuentoPorcentaje > 0}">
                                                                            ${detalle.descuentoPorcentaje}%
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            -
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end fw-bold">$<fmt:formatNumber value="${detalle.total}" pattern="#,##0"/></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Información Adicional -->
                                    <c:if test="${not empty cotizacion.notas || not empty cotizacion.terminos}">
                                        <div class="row">
                                            <c:if test="${not empty cotizacion.notas}">
                                                <div class="col-md-6">
                                                    <h5 class="text-primary mb-3"><i class="fas fa-sticky-note me-2"></i>Notas</h5>
                                                    <div class="card bg-light">
                                                        <div class="card-body">
                                                            <p class="mb-0">${cotizacion.notas}</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty cotizacion.terminos}">
                                                <div class="col-md-6">
                                                    <h5 class="text-primary mb-3"><i class="fas fa-file-contract me-2"></i>Términos y Condiciones</h5>
                                                    <div class="card bg-light">
                                                        <div class="card-body">
                                                            <p class="mb-0">${cotizacion.terminos}</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning text-center">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No se pudo cargar la información de la cotización.
                                <a href="${pageContext.request.contextPath}/cotizaciones" class="alert-link ms-2">
                                    Volver a la lista de cotizaciones
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

                sidebar.classList.toggle('sidebar-collapsed');
                mainContent.classList.toggle('main-content-expanded');
            });
            // Auto-cerrar alerts después de 5 segundos
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);

            // Función para imprimir
            document.querySelector('.btn-outline-custom[title="Imprimir"]').addEventListener('click', function () {
                window.print();
            });
        </script>
    </body>
</html>