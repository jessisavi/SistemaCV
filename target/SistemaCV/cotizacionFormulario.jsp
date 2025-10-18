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
        <title>
            <c:choose>
                <c:when test="${not empty cotizacion}">Editar Cotización | Sistema CV</c:when>
                <c:otherwise>Nueva Cotización | Sistema CV</c:otherwise>
            </c:choose>
        </title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCOTFOR.css">
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
                            <h4 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty cotizacion}">Editar Cotización</c:when>
                                    <c:otherwise>Stylish Home</c:otherwise>
                                </c:choose>
                            </h4>
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
                            <h2 class="mb-1">
                                <i class="fas fa-file-invoice-dollar me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty cotizacion}">Stylish Home ${cotizacion.numeroCotizacion}</c:when>
                                    <c:otherwise>Nueva Cotización</c:otherwise>
                                </c:choose>
                            </h2>
                            <p class="text-muted mb-0">
                                <c:choose>
                                    <c:when test="${not empty cotizacion}">Modifique la información de la cotización</c:when>
                                    <c:otherwise>Complete la información para crear una nueva cotización</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/cotizaciones" class="btn btn-outline-custom me-2">
                                <i class="fas fa-arrow-left me-2"></i> Volver
                            </a>
                            <button type="button" class="btn btn-outline-custom" onclick="calcularTotales()">
                                <i class="fas fa-calculator me-2"></i> Calcular
                            </button>
                        </div>
                    </div>

                    <form id="cotizacionForm" method="post" 
                          action="${pageContext.request.contextPath}/cotizaciones/guardar">

                        <c:if test="${not empty cotizacion}">
                            <input type="hidden" name="id" value="${cotizacion.idcotizacion}">
                        </c:if>

                        <!-- Información Básica -->
                        <div class="card card-custom mb-4">
                            <div class="card-header card-header-custom">
                                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información Básica</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="clienteId" class="form-label fw-bold">Cliente <span class="text-danger">*</span></label>
                                            <select class="form-select" id="clienteId" name="clienteId" required>
                                                <option value="">Seleccione un cliente</option>
                                                <c:forEach var="cliente" items="${clientes}">
                                                    <option value="${cliente.idcliente}" 
                                                            <c:if test="${not empty cotizacion && cotizacion.clienteId == cliente.idcliente}">selected</c:if>>
                                                        ${cliente.nombre} ${cliente.apellido} - ${cliente.correoElectronico}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="proyecto" class="form-label fw-bold">Proyecto</label>
                                            <input type="text" class="form-control" id="proyecto" name="proyecto" 
                                                   value="${cotizacion.proyecto}" placeholder="Nombre del proyecto">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="fecha" class="form-label fw-bold">Fecha <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="fecha" name="fecha" 
                                                   value="<c:choose><c:when test='${not empty cotizacion.fecha}'>${cotizacion.fecha}</c:when><c:otherwise>${fechaActual}</c:otherwise></c:choose>" 
                                                           required>
                                                   </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-3">
                                                    <label for="validoHasta" class="form-label fw-bold">Válido hasta <span class="text-danger">*</span></label>
                                                    <input type="date" class="form-control" id="validoHasta" name="validoHasta" 
                                                           value="<c:choose><c:when test='${not empty cotizacion.validoHasta}'>${cotizacion.validoHasta}</c:when><c:otherwise>${fechaValido}</c:otherwise></c:choose>" 
                                                        required>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-3">
                                                    <label class="form-label fw-bold">Estado</label>
                                                    <div class="form-control bg-light">
                                                <c:choose>
                                                    <c:when test="${not empty cotizacion}">
                                                        <span class="badge
                                                              <c:choose>
                                                                  <c:when test="${cotizacion.estado == 'PENDIENTE'}">bg-warning</c:when>
                                                                  <c:when test="${cotizacion.estado == 'APROBADA'}">bg-success</c:when>
                                                                  <c:when test="${cotizacion.estado == 'RECHAZADA'}">bg-danger</c:when>
                                                                  <c:otherwise>bg-info</c:otherwise>
                                                              </c:choose>">
                                                            ${cotizacion.estado}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">PENDIENTE</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Productos y Servicios -->
                        <div class="card card-custom mb-4">
                            <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                <h5 class="mb-0"><i class="fas fa-boxes me-2"></i>Productos y Servicios</h5>
                                <button type="button" class="btn btn-sm btn-custom" onclick="agregarProducto()">
                                    <i class="fas fa-plus me-1"></i>Agregar Producto
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" id="tablaProductos">
                                        <thead class="table-dark">
                                            <tr>
                                                <th width="40%">Producto</th>
                                                <th width="15%">Cantidad</th>
                                                <th width="15%">Precio Unitario</th>
                                                <th width="15%">Descuento</th>
                                                <th width="15%">Total</th>
                                                <th width="5%"></th>
                                            </tr>
                                        </thead>
                                        <tbody id="cuerpoTabla">
                                            <c:choose>
                                                <c:when test="${not empty cotizacion && not empty cotizacion.detalles}">
                                                    <c:forEach var="detalle" items="${cotizacion.detalles}" varStatus="status">
                                                        <tr class="fila-producto">
                                                            <td>
                                                                <select class="form-select producto-select" name="productoId" required>
                                                                    <option value="">Seleccione producto</option>
                                                                    <c:forEach var="producto" items="${productos}">
                                                                        <option value="${producto.id}" 
                                                                                <c:if test="${detalle.productoId == producto.id}">selected</c:if>
                                                                                data-precio="${producto.precio}">
                                                                            ${producto.nombre} - $<fmt:formatNumber value="${producto.precio}" pattern="#,##0"/>
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </td>
                                                            <td>
                                                                <input type="number" class="form-control cantidad" name="cantidad" 
                                                                       value="${detalle.cantidad}" min="1" required>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control precio" name="precioUnitario" 
                                                                       value="<fmt:formatNumber value='${detalle.precioUnitario}' pattern='#,##0'/>" required>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control descuento" name="descuento" 
                                                                       value="<c:choose><c:when test='${not empty detalle.descuentoPorcentaje}'>${detalle.descuentoPorcentaje}%</c:when><c:when test='${not empty detalle.descuentoMonto}'>$<fmt:formatNumber value='${detalle.descuentoMonto}' pattern='#,##0'/></c:when></c:choose>">
                                                                       </td>
                                                                       <td>
                                                                           <input type="text" class="form-control total-linea" 
                                                                                  value="<fmt:formatNumber value='${detalle.total}' pattern='#,##0'/>" readonly>
                                                            </td>
                                                            <td>
                                                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarFila(this)">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Fila vacía por defecto -->
                                                    <tr class="fila-producto">
                                                        <td>
                                                            <select class="form-select producto-select" name="productoId" required>
                                                                <option value="">Seleccione producto</option>
                                                                <c:forEach var="producto" items="${productos}">
                                                                    <option value="${producto.id}" data-precio="${producto.precio}">
                                                                        ${producto.nombre} - $<fmt:formatNumber value="${producto.precio}" pattern="#,##0"/>
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            <input type="number" class="form-control cantidad" name="cantidad" value="1" min="1" required>
                                                        </td>
                                                        <td>
                                                            <input type="text" class="form-control precio" name="precioUnitario" value="0" required>
                                                        </td>
                                                        <td>
                                                            <input type="text" class="form-control descuento" name="descuento" placeholder="0% o $0">
                                                        </td>
                                                        <td>
                                                            <input type="text" class="form-control total-linea" value="0" readonly>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarFila(this)">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Resumen y Totales -->
                        <div class="card card-custom mb-4">
                            <div class="card-header card-header-custom">
                                <h5 class="mb-0"><i class="fas fa-calculator me-2"></i>Resumen Financiero</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="mb-3">
                                            <label for="notas" class="form-label fw-bold">Notas</label>
                                            <textarea class="form-control" id="notas" name="notas" rows="3" 
                                                      placeholder="Notas adicionales para la cotización">${cotizacion.notas}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label for="terminos" class="form-label fw-bold">Términos y Condiciones</label>
                                            <textarea class="form-control" id="terminos" name="terminos" rows="3" 
                                                      placeholder="Términos y condiciones de la cotización">${cotizacion.terminos}</textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="bg-light p-3 rounded">
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
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Botones de Acción -->
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/cotizaciones" class="btn btn-outline-custom">
                                <i class="fas fa-times me-2"></i>Cancelar
                            </a>
                            <div>
                                <button type="button" class="btn btn-outline-custom me-2" onclick="calcularTotales()">
                                    <i class="fas fa-calculator me-2"></i>Calcular
                                </button>
                                <button type="submit" class="btn btn-custom">
                                    <i class="fas fa-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty cotizacion}">Actualizar Cotización</c:when>
                                        <c:otherwise>Crear Cotización</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </div>
                    </form>
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

                                    // Función auxiliar para formatear moneda
                                    function formatCurrency(amount) {
                                        if (!amount && amount !== 0)
                                            return '$0';
                                        return '$' + parseFloat(amount).toLocaleString('es-CO', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        });
                                    }

                                    // Funciones para el formulario de cotización
                                    function agregarProducto() {
                                        const tbody = document.getElementById('cuerpoTabla');
                                        const nuevaFila = document.createElement('tr');
                                        nuevaFila.className = 'fila-producto';
                                        nuevaFila.innerHTML = `
                                        <td>
                                            <select class="form-select producto-select" name="productoId" required>
                                                <option value="">Seleccione producto</option>
            <c:forEach var="producto" items="${productos}">
                                                    <option value="${producto.id}" data-precio="${producto.precio}">
                ${producto.nombre} - $<fmt:formatNumber value="${producto.precio}" pattern="#,##0"/>
                                                    </option>
            </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="number" class="form-control cantidad" name="cantidad" value="1" min="1" required>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control precio" name="precioUnitario" value="$0" readonly>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control descuento" name="descuento" placeholder="0% o $0">
                                        </td>
                                        <td>
                                            <input type="text" class="form-control total-linea" value="$0" readonly>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarFila(this)">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </td>
                                    `;
                                        tbody.appendChild(nuevaFila);

                                        // Agregar event listeners a los nuevos campos
                                        agregarEventListeners(nuevaFila);
                                    }

                                    function eliminarFila(boton) {
                                        const fila = boton.closest('tr');
                                        if (document.querySelectorAll('.fila-producto').length > 1) {
                                            fila.remove();
                                            calcularTotales();
                                        } else {
                                            alert('Debe haber al menos un producto en la cotización');
                                        }
                                    }

                                    function agregarEventListeners(fila) {
                                        const selectProducto = fila.querySelector('.producto-select');
                                        const inputCantidad = fila.querySelector('.cantidad');
                                        const inputPrecio = fila.querySelector('.precio');
                                        const inputDescuento = fila.querySelector('.descuento');

                                        selectProducto.addEventListener('change', function () {
                                            const precio = this.options[this.selectedIndex]?.dataset.precio || 0;
                                            inputPrecio.value = formatCurrency(precio);
                                            calcularLinea(fila);
                                        });

                                        inputCantidad.addEventListener('input', () => calcularLinea(fila));
                                        inputPrecio.addEventListener('input', () => calcularLinea(fila));
                                        inputDescuento.addEventListener('input', () => calcularLinea(fila));
                                    }

                                    function calcularLinea(fila) {
                                        const cantidad = parseFloat(fila.querySelector('.cantidad').value) || 0;
                                        const precioInput = fila.querySelector('.precio');
                                        const precio = parseFloat(precioInput.value.replace(/[^\d.-]/g, '')) || 0;
                                        const descuento = fila.querySelector('.descuento').value;
                                        const totalLinea = fila.querySelector('.total-linea');

                                        let subtotal = cantidad * precio;
                                        let descuentoValor = 0;

                                        if (descuento.includes('%')) {
                                            const porcentaje = parseFloat(descuento) || 0;
                                            descuentoValor = subtotal * (porcentaje / 100);
                                        } else {
                                            descuentoValor = parseFloat(descuento.replace(/[^\d.-]/g, '')) || 0;
                                        }

                                        const total = Math.max(0, subtotal - descuentoValor);
                                        totalLinea.value = formatCurrency(total);
                                    }

                                    function calcularTotales() {
                                        const filas = document.querySelectorAll('.fila-producto');
                                        let subtotal = 0;
                                        let descuentoTotal = 0;

                                        filas.forEach(fila => {
                                            const totalLinea = parseFloat(fila.querySelector('.total-linea').value.replace(/[^\d.-]/g, '')) || 0;
                                            const precio = parseFloat(fila.querySelector('.precio').value.replace(/[^\d.-]/g, '')) || 0;
                                            const cantidad = parseFloat(fila.querySelector('.cantidad').value) || 0;
                                            const descuento = fila.querySelector('.descuento').value;

                                            let descuentoLinea = 0;
                                            if (descuento.includes('%')) {
                                                const porcentaje = parseFloat(descuento) || 0;
                                                descuentoLinea = (cantidad * precio) * (porcentaje / 100);
                                            } else {
                                                descuentoLinea = parseFloat(descuento.replace(/[^\d.-]/g, '')) || 0;
                                            }

                                            subtotal += cantidad * precio;
                                            descuentoTotal += descuentoLinea;
                                        });

                                        const iva = (subtotal - descuentoTotal) * 0.19;
                                        const total = subtotal - descuentoTotal + iva;

                                        document.getElementById('subtotal').textContent = formatCurrency(subtotal);
                                        document.getElementById('descuentoTotal').textContent = formatCurrency(descuentoTotal);
                                        document.getElementById('iva').textContent = formatCurrency(iva);
                                        document.getElementById('total').textContent = formatCurrency(total);
                                    }

                                    // Inicializar event listeners en las filas existentes
                                    document.addEventListener('DOMContentLoaded', function () {
                                        document.querySelectorAll('.fila-producto').forEach(fila => {
                                            agregarEventListeners(fila);
                                        });
                                        calcularTotales();
                                    });

                                    // Validación del formulario antes de enviar
                                    document.getElementById('cotizacionForm').addEventListener('submit', function (e) {
                                        const filas = document.querySelectorAll('.fila-producto');
                                        let tieneProductosValidos = false;

                                        filas.forEach(fila => {
                                            const productoId = fila.querySelector('.producto-select').value;
                                            const cantidad = fila.querySelector('.cantidad').value;
                                            const precio = fila.querySelector('.precio').value;

                                            if (productoId && cantidad > 0 && precio && parseFloat(precio.replace(/[^\d.-]/g, '')) > 0) {
                                                tieneProductosValidos = true;
                                            }
                                        });

                                        if (!tieneProductosValidos) {
                                            e.preventDefault();
                                            alert('Debe agregar al menos un producto válido a la cotización');
                                            return;
                                        }
                                        calcularTotales();
                                    });
        </script>
    </body>
</html>