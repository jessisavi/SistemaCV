<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${empty venta ? 'Nueva Venta' : 'Editar Venta'} | Sistema Comercial</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleVF.css">
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
                            <h4 class="mb-0">Pedido Nuevo</h4>
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
                        <h2 class="mb-0">
                            <i class="fas fa-shopping-cart me-2"></i> 
                            ${empty venta ? 'Registrar Nueva Venta' : 'Editar Venta'}
                        </h2>
                        <a href="${pageContext.request.contextPath}/ventas" class="btn btn-outline-custom">
                            <i class="fas fa-arrow-left me-2"></i>Volver a Ventas
                        </a>
                    </div>

                    <div class="card card-custom">
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/ventas/guardar" id="ventaForm">
                                <c:if test="${not empty venta}">
                                    <input type="hidden" name="id" value="${venta.idventa}">
                                </c:if>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="clienteId" class="form-label">Cliente <span class="text-danger">*</span></label>
                                            <select class="form-select" id="clienteId" name="clienteId" required>
                                                <option value="">Seleccionar cliente...</option>
                                                <c:forEach var="cliente" items="${clientes}">
                                                    <option value="${cliente.idcliente}" 
                                                            ${not empty venta && venta.idcliente == cliente.idcliente ? 'selected' : ''}>
                                                        ${cliente.nombreCompleto}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label for="fecha" class="form-label">Fecha de Venta <span class="text-danger">*</span></label>
                                            <input type="date" class="form-control" id="fecha" name="fecha" 
                                                   value="${not empty venta ? venta.fecha : fechaActual}" required>
                                        </div>

                                        <div class="mb-3">
                                            <label for="metodoPago" class="form-label">Método de Pago <span class="text-danger">*</span></label>
                                            <select class="form-select" id="metodoPago" name="metodoPago" required>
                                                <option value="EFECTIVO" ${not empty venta && venta.metodoPago == 'EFECTIVO' ? 'selected' : ''}>Efectivo</option>
                                                <option value="TARJETA_CREDITO" ${not empty venta && venta.metodoPago == 'TARJETA_CREDITO' ? 'selected' : ''}>Tarjeta de Crédito</option>
                                                <option value="TRANSFERENCIA" ${not empty venta && venta.metodoPago == 'TRANSFERENCIA' ? 'selected' : ''}>Transferencia Bancaria</option>
                                                <option value="CHEQUE" ${not empty venta && venta.metodoPago == 'CHEQUE' ? 'selected' : ''}>Cheque</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">N° Factura</label>
                                            <input type="text" class="form-control" value="${venta.numeroFactura}" readonly>
                                            <small class="text-muted">Generado automáticamente</small>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Vendedor</label>
                                            <input type="text" class="form-control" value="Asesor Comercial" readonly>
                                        </div>

                                        <div class="mb-3">
                                            <label for="estado" class="form-label">Estado <span class="text-danger">*</span></label>
                                            <select class="form-select" id="estado" name="estado" required>
                                                <option value="PENDIENTE" ${not empty venta && venta.estado == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                                                <option value="COMPLETADA" ${not empty venta && venta.estado == 'COMPLETADA' ? 'selected' : ''}>Completada</option>
                                                <option value="CANCELADA" ${not empty venta && venta.estado == 'CANCELADA' ? 'selected' : ''}>Cancelada</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <h5 class="mb-3">Productos <span class="text-danger">*</span></h5>

                                <div class="table-responsive mb-3">
                                    <table class="table" id="productosTable">
                                        <thead>
                                            <tr>
                                                <th width="5%">#</th>
                                                <th width="40%">Producto</th>
                                                <th width="15%">Cantidad</th>
                                                <th width="20%">Precio Unit.</th>
                                                <th width="20%">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody id="productosBody">
                                            <c:choose>
                                                <c:when test="${not empty venta && not empty venta.detalles}">
                                                    <c:forEach var="detalle" items="${venta.detalles}" varStatus="status">
                                                        <tr>
                                                            <td>${status.index + 1}</td>
                                                            <td>
                                                                <select class="form-select producto-select" name="productoId" required>
                                                                    <option value="">Seleccionar producto...</option>
                                                                    <c:forEach var="producto" items="${productos}">
                                                                        <option value="${producto.id}" 
                                                                                data-precio="${producto.precio}"
                                                                                ${detalle.idproducto == producto.id ? 'selected' : ''}>
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
                                                                       value="<fmt:formatNumber value='${detalle.precioUnitario}' pattern="#,##0"/>" readonly>
                                                            </td>
                                                            <td>
                                                                <input type="text" class="form-control total" 
                                                                       value="<fmt:formatNumber value='${detalle.total}' pattern="#,##0"/>" readonly>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td>1</td>
                                                        <td>
                                                            <select class="form-select producto-select" name="productoId" required>
                                                                <option value="">Seleccionar producto...</option>
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
                                                            <input type="text" class="form-control total" value="$0" readonly>
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="mb-3">
                                    <button type="button" class="btn btn-sm btn-outline-custom" id="agregarProducto">
                                        <i class="fas fa-plus me-2"></i>Agregar Producto
                                    </button>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="notas" class="form-label">Notas</label>
                                            <textarea class="form-control" id="notas" name="notas" rows="3" 
                                                      placeholder="Observaciones adicionales...">${venta.notas}</textarea>
                                        </div>
                                    </div>
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

                                <div class="d-flex justify-content-end mt-4">
                                    <a href="${pageContext.request.contextPath}/ventas" class="btn btn-secondary me-2">
                                        <i class="fas fa-times me-2"></i>Cancelar
                                    </a>
                                    <button type="submit" class="btn btn-custom">
                                        <i class="fas fa-save me-2"></i>${empty venta ? 'Guardar Venta' : 'Actualizar Venta'}
                                    </button>
                                </div>
                            </form>
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

            // Funcionalidad para agregar productos
            document.getElementById('agregarProducto').addEventListener('click', function () {
                const tbody = document.getElementById('productosBody');
                const rowCount = tbody.children.length + 1;

                const newRow = document.createElement('tr');
                newRow.innerHTML = `
                    <td>${rowCount}</td>
                    <td>
                        <select class="form-select producto-select" name="productoId" required>
                            <option value="">Seleccionar producto...</option>
            <c:forEach var="producto" items="${productos}">
                                <option value="${producto.id}" data-precio="${producto.precio}">
                ${producto.nombre} - <fmt:formatNumber value="${producto.precio}" pattern="#,##0"/>
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
                        <input type="text" class="form-control total" value="$0" readonly>
                    </td>
                `;

                tbody.appendChild(newRow);

                // Agregar event listeners a los nuevos elementos
                agregarEventListeners(newRow);
            });

            // Función para agregar event listeners a una fila
            function agregarEventListeners(row) {
                const productoSelect = row.querySelector('.producto-select');
                const cantidadInput = row.querySelector('.cantidad');
                const precioInput = row.querySelector('.precio');
                const totalInput = row.querySelector('.total');

                function actualizarPrecioYTotal() {
                    const selectedOption = productoSelect.options[productoSelect.selectedIndex];
                    const precio = selectedOption ? parseFloat(selectedOption.getAttribute('data-precio')) || 0 : 0;
                    const cantidad = parseInt(cantidadInput.value) || 0;
                    const total = precio * cantidad;

                    precioInput.value = new Intl.NumberFormat('es-CO', {
                        style: 'currency',
                        currency: 'COP'
                    }).format(precio);

                    totalInput.value = new Intl.NumberFormat('es-CO', {
                        style: 'currency',
                        currency: 'COP'
                    }).format(total);

                    calcularTotales();
                }

                productoSelect.addEventListener('change', actualizarPrecioYTotal);
                cantidadInput.addEventListener('input', actualizarPrecioYTotal);

                // Inicializar si hay valores
                actualizarPrecioYTotal();
            }

            // Calcular totales generales
            function calcularTotales() {
                let subtotal = 0;

                document.querySelectorAll('#productosBody tr').forEach(row => {
                    const totalInput = row.querySelector('.total');
                    const totalValue = totalInput.value.replace(/[^\d.-]/g, '');
                    subtotal += parseFloat(totalValue) || 0;
                });

                const iva = subtotal * 0.19;
                const total = subtotal + iva;

                document.getElementById('subtotal').textContent = new Intl.NumberFormat('es-CO', {
                    style: 'currency',
                    currency: 'COP'
                }).format(subtotal);

                document.getElementById('iva').textContent = new Intl.NumberFormat('es-CO', {
                    style: 'currency',
                    currency: 'COP'
                }).format(iva);

                document.getElementById('total').textContent = new Intl.NumberFormat('es-CO', {
                    style: 'currency',
                    currency: 'COP'
                }).format(total);
            }

            // Inicializar event listeners para las filas existentes
            document.querySelectorAll('#productosBody tr').forEach(row => {
                agregarEventListeners(row);
            });

            // Validación del formulario
            document.getElementById('ventaForm').addEventListener('submit', function (e) {
                const productos = document.querySelectorAll('.producto-select');
                let tieneProductos = false;

                productos.forEach(select => {
                    if (select.value) {
                        tieneProductos = true;
                    }
                });

                if (!tieneProductos) {
                    e.preventDefault();
                    alert('Debe agregar al menos un producto a la venta.');
                    return;
                }

                const total = parseFloat(document.getElementById('total').textContent.replace(/[^\d.-]/g, ''));
                if (total <= 0) {
                    e.preventDefault();
                    alert('El total de la venta debe ser mayor a cero.');
                    return;
                }
            });
        </script>
    </body>
</html>