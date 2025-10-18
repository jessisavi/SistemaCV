<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, portalempleado.modelos.*, java.util.Map, java.time.format.DateTimeFormatter" %>
<%
    List<InformeVentas> ventas = (List<InformeVentas>) request.getAttribute("ventas");
    List<InformeCotizaciones> cotizaciones = (List<InformeCotizaciones>) request.getAttribute("cotizaciones");
    List<InformePedidos> pedidos = (List<InformePedidos>) request.getAttribute("pedidos");
    Map<String, Object> estadisticasVentas = (Map<String, Object>) request.getAttribute("estadisticasVentas");
    Map<String, Object> estadisticasCotizaciones = (Map<String, Object>) request.getAttribute("estadisticasCotizaciones");
    List<Map<String, Object>> productosMasVendidos = (List<Map<String, Object>>) request.getAttribute("productosMasVendidos");
    
    java.time.LocalDate fechaInicio = (java.time.LocalDate) request.getAttribute("fechaInicio");
    java.time.LocalDate fechaFin = (java.time.LocalDate) request.getAttribute("fechaFin");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    // Calcular totales
    Number totalIngresos = (Number) estadisticasVentas.getOrDefault("totalIngresos", 0);
    Number promedioVenta = (Number) estadisticasVentas.getOrDefault("promedioVenta", 0);
    Number totalVentas = (Number) estadisticasVentas.getOrDefault("totalVentas", 0);
    
    Number totalCotizaciones = (Number) estadisticasCotizaciones.getOrDefault("totalCotizaciones", 0);
    Number cotizacionesAprobadas = (Number) estadisticasCotizaciones.getOrDefault("aprobadas", 0);
    Number cotizacionesPendientes = (Number) estadisticasCotizaciones.getOrDefault("pendientes", 0);
    
    // Datos para gráficos (simulados por ahora)
    int[] ventasMensuales = {400, 420, 430, 490, 450, 460, 400, 490, 510, 520, 540, 570};
    int[] estadosCotizaciones = {45, 15, 8, 5}; // Aprobadas, Pendientes, Rechazadas, Vencidas
    int[] tasaConversion = {55, 60, 64, 69, 73, 75};
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Informes | Sistema Comercial</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleINFO.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts - Roboto -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/informes">
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
                            <h4 class="mb-0">Informes y Estadísticas</h4>
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
                    <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="alert alert-<%= request.getAttribute("tipoMensaje") %> alert-dismissible fade show" role="alert">
                        <%= request.getAttribute("mensaje") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Generación de Informes</h2>
                        <button class="btn btn-custom" onclick="exportarTodos()">
                            <i class="fas fa-file-export me-2"></i>Exportar Todos
                        </button>
                    </div>

                    <!-- Tarjetas de resumen -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom report-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title text-success">Ventas</h5>
                                            <h3 class="text-success">$<%= String.format("%,d", totalIngresos.longValue()) %></h3>
                                            <p class="card-text"><%= totalVentas %> transacciones</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-shopping-cart"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom report-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title text-primary">Cotizaciones</h5>
                                            <h3 class="text-primary"><%= totalCotizaciones %></h3>
                                            <p class="card-text"><%= cotizacionesAprobadas %> aprobadas</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom report-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title text-warning">Pedidos</h5>
                                            <h3 class="text-warning"><%= pedidos != null ? pedidos.size() : 0 %></h3>
                                            <p class="card-text">En proceso</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-clipboard-list"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom report-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title text-info">Promedio Venta</h5>
                                            <h3 class="text-info">$<%= String.format("%,d", promedioVenta.longValue()) %></h3>
                                            <p class="card-text">Por transacción</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-chart-line"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Enlaces a informes detallados -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card card-custom report-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title">Informe de Ventas</h5>
                                            <p class="card-text">Análisis detallado de ventas por período</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-shopping-cart"></i>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <a href="${pageContext.request.contextPath}/informes/ventas?fechaInicio=<%= fechaInicio.format(formatter) %>&fechaFin=<%= fechaFin.format(formatter) %>" 
                                           class="btn btn-outline-custom me-2">
                                            <i class="fas fa-eye me-2"></i>Ver Detalle
                                        </a>
                                        <button class="btn btn-outline-secondary" onclick="exportarVentas()">
                                            <i class="fas fa-download me-2"></i>Descargar
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-custom report-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title">Informe de Cotizaciones</h5>
                                            <p class="card-text">Seguimiento de cotizaciones y conversión</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <a href="${pageContext.request.contextPath}/informes/cotizaciones?fechaInicio=<%= fechaInicio.format(formatter) %>&fechaFin=<%= fechaFin.format(formatter) %>" 
                                           class="btn btn-outline-custom me-2">
                                            <i class="fas fa-eye me-2"></i>Ver Detalle
                                        </a>
                                        <button class="btn btn-outline-secondary" onclick="exportarCotizaciones()">
                                            <i class="fas fa-download me-2"></i>Descargar
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-custom report-card h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title">Informe de Pedidos</h5>
                                            <p class="card-text">Estado y seguimiento de pedidos</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-clipboard-list"></i>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <a href="${pageContext.request.contextPath}/informes/pedidos?fechaInicio=<%= fechaInicio.format(formatter) %>&fechaFin=<%= fechaFin.format(formatter) %>" 
                                           class="btn btn-outline-custom me-2">
                                            <i class="fas fa-eye me-2"></i>Ver Detalle
                                        </a>
                                        <button class="btn btn-outline-secondary" onclick="exportarPedidos()">
                                            <i class="fas fa-download me-2"></i>Descargar
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filtros -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="date-range-picker">
                                <h5 class="mb-3"><i class="fas fa-calendar-alt me-2"></i> Seleccionar Período</h5>
                                <form method="post" action="${pageContext.request.contextPath}/informes">
                                    <div class="row">
                                        <div class="col-md-3 mb-2">
                                            <label for="startDate" class="form-label">Fecha Inicio</label>
                                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                                   value="<%= fechaInicio.format(formatter) %>">
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <label for="endDate" class="form-label">Fecha Fin</label>
                                            <input type="date" class="form-control" id="endDate" name="endDate"
                                                   value="<%= fechaFin.format(formatter) %>">
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <label for="reportType" class="form-label">Tipo de Informe</label>
                                            <select class="form-select" id="reportType" name="reportType">
                                                <option value="Resumen General" selected>Resumen General</option>
                                                <option value="Resumen Detallado">Resumen Detallado</option>
                                                <option value="Vendedor">Vendedor</option>
                                                <option value="Cliente">Cliente</option>
                                                <option value="Producto">Producto</option>
                                                <option value="Cotización">Cotización</option>
                                                <option value="Pedido">Pedido</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3 d-flex align-items-end mb-2">
                                            <button type="submit" class="btn btn-custom w-100">
                                                <i class="fas fa-filter me-2"></i>Filtrar
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Gráficos y Estadísticas -->
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Ventas Mensuales</h5>
                                    <div>
                                        <button class="btn btn-sm btn-outline-secondary me-2" onclick="imprimirGrafico('salesChart')">
                                            <i class="fas fa-print me-1"></i>Imprimir
                                        </button>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="exportarGrafico('salesChart')">
                                            <i class="fas fa-download me-1"></i>Excel
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="salesChart"></canvas>
                                    </div>
                                    <div class="text-center mt-3">
                                        <h6 class="text-success">Nota: El valor de las ventas es expresado en miles</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4" style="height: 422px;">
                            <div class="card card-custom h-100">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Resumen de Ventas</h5>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-3">
                                        <span>Total Ventas:</span>
                                        <span class="fw-bold">$<%= String.format("%,d", totalIngresos.longValue()) %></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span>Ventas Promedio:</span>
                                        <span class="fw-bold">$<%= String.format("%,d", promedioVenta.longValue()) %></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span>Cantidad de Transacciones:</span>
                                        <span class="fw-bold"><%= totalVentas %></span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <span>Pagos en Efectivo:</span>
                                        <%
                                            Number totalEfectivo = (Number) estadisticasVentas.getOrDefault("totalEfectivo", 0);
                                        %>
                                        <span class="fw-bold">$<%= String.format("%,d", totalEfectivo.longValue()) %></span>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between fw-bold text-success">
                                        <span>Período:</span>
                                        <span><%= fechaInicio.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %> - 
                                            <%= fechaFin.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Más gráficos -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card card-custom" style="height: 415px;">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Estado de Cotizaciones</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="quotesChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Tasa de Conversión</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="conversionChart"></canvas>
                                    </div>
                                    <div class="text-center mt-3">
                                        <h6 class="text-success">75% de conversión de cotización a venta</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de Pedidos -->
                    <div class="card card-custom mb-4">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">Detalle de Pedidos</h5>
                            <div>
                                <button class="btn btn-sm btn-outline-secondary me-2" onclick="imprimirTabla()">
                                    <i class="fas fa-print me-1"></i>Imprimir
                                </button>
                                <button class="btn btn-sm btn-outline-secondary" onclick="exportarTabla()">
                                    <i class="fas fa-download me-1"></i>Exportar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="tablaPedidos">
                                    <thead>
                                        <tr>
                                            <th>N° Factura</th>
                                            <th>Cliente</th>
                                            <th>Fecha</th>
                                            <th>Productos</th>
                                            <th>Total</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (pedidos != null && !pedidos.isEmpty()) { 
                                        for (InformePedidos pedido : pedidos) { %>
                                        <tr>
                                            <td><%= pedido.getNumeroPedido() %></td>
                                            <td><%= pedido.getCliente() %></td>
                                            <td><%= pedido.getFecha().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></td>
                                            <td><%= pedido.getCantidadProductos() %></td>
                                            <td>$<%= String.format("%,d", pedido.getTotal().longValue()) %></td>
                                            <td>
                                                <span class="badge
                                                      <%= pedido.getEstado().equals("COMPLETADA") ? "bg-success" : 
                                                          pedido.getEstado().equals("PENDIENTE") ? "bg-warning text-dark" : 
                                                          pedido.getEstado().equals("CANCELADA") ? "bg-danger" : "bg-secondary" %>">
                                                    <%= pedido.getEstado() %>
                                                </span>
                                            </td>
                                        </tr>
                                        <% } 
                                    } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center">No hay pedidos en el período seleccionado</td>
                                        </tr>
                                        <% } %>
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
                                    // Toggle sidebar
                                    document.getElementById('toggleSidebar').addEventListener('click', function () {
                                        const sidebar = document.getElementById('sidebar');
                                        const mainContent = document.getElementById('mainContent');

                                        sidebar.classList.toggle('sidebar-collapsed');
                                        mainContent.classList.toggle('main-content-expanded');
                                    });

                                    // Gráfico de Ventas
                                    const salesCtx = document.getElementById('salesChart').getContext('2d');
                                    const salesChart = new Chart(salesCtx, {
                                        type: 'bar',
                                        data: {
                                            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                                            datasets: [{
                                                    label: 'Ventas 2024',
                                                    data: <%= java.util.Arrays.toString(ventasMensuales) %>,
                                                    backgroundColor: 'rgba(203, 154, 40, 0.7)',
                                                    borderColor: 'rgba(203, 154, 40, 1)',
                                                    borderWidth: 1
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            scales: {
                                                y: {
                                                    beginAtZero: true,
                                                    ticks: {
                                                        callback: function (value) {
                                                            return '$' + value.toLocaleString();
                                                        }
                                                    }
                                                }
                                            },
                                            plugins: {
                                                tooltip: {
                                                    callbacks: {
                                                        label: function (context) {
                                                            return '$' + context.raw.toLocaleString();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    // Gráfico de Cotizaciones
                                    const quotesCtx = document.getElementById('quotesChart').getContext('2d');
                                    const quotesChart = new Chart(quotesCtx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: ['Aprobadas', 'Pendientes', 'Rechazadas', 'Vencidas'],
                                            datasets: [{
                                                    data: <%= java.util.Arrays.toString(estadosCotizaciones) %>,
                                                    backgroundColor: [
                                                        'rgba(40, 167, 69, 0.7)',
                                                        'rgba(255, 193, 7, 0.7)',
                                                        'rgba(220, 53, 69, 0.7)',
                                                        'rgba(108, 117, 125, 0.7)'
                                                    ],
                                                    borderColor: [
                                                        'rgba(40, 167, 69, 1)',
                                                        'rgba(255, 193, 7, 1)',
                                                        'rgba(220, 53, 69, 1)',
                                                        'rgba(108, 117, 125, 1)'
                                                    ],
                                                    borderWidth: 1
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: {
                                                    position: 'right',
                                                }
                                            }
                                        }
                                    });

                                    // Gráfico de Conversión
                                    const conversionCtx = document.getElementById('conversionChart').getContext('2d');
                                    const conversionChart = new Chart(conversionCtx, {
                                        type: 'line',
                                        data: {
                                            labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
                                            datasets: [{
                                                    label: 'Tasa de Conversión',
                                                    data: <%= java.util.Arrays.toString(tasaConversion) %>,
                                                    backgroundColor: 'rgba(40, 167, 69, 0.2)',
                                                    borderColor: 'rgba(40, 167, 69, 1)',
                                                    borderWidth: 2,
                                                    tension: 0.4,
                                                    fill: true
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            scales: {
                                                y: {
                                                    beginAtZero: false,
                                                    min: 45,
                                                    max: 90,
                                                    ticks: {
                                                        callback: function (value) {
                                                            return value + '%';
                                                        }
                                                    }
                                                }
                                            },
                                            plugins: {
                                                tooltip: {
                                                    callbacks: {
                                                        label: function (context) {
                                                            return context.raw + '%';
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    // Funciones de exportación
                                    function exportarTodos() {
                                        if (confirm('¿Está seguro de que desea exportar todos los informes?')) {
                                            const fechaInicio = document.getElementById('startDate').value;
                                            const fechaFin = document.getElementById('endDate').value;
                                            window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=todos&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                        }
                                    }

                                    function exportarVentas() {
                                        const fechaInicio = document.getElementById('startDate').value;
                                        const fechaFin = document.getElementById('endDate').value;
                                        window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=ventas&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                    }

                                    function exportarCotizaciones() {
                                        const fechaInicio = document.getElementById('startDate').value;
                                        const fechaFin = document.getElementById('endDate').value;
                                        window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=cotizaciones&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                    }

                                    function exportarPedidos() {
                                        const fechaInicio = document.getElementById('startDate').value;
                                        const fechaFin = document.getElementById('endDate').value;
                                        window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=pedidos&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                    }

                                    function imprimirGrafico(chartId) {
                                        const chartCanvas = document.getElementById(chartId);
                                        const printWindow = window.open('', '_blank');
                                        printWindow.document.write(`
                                        <html>
                                            <head>
                                                <title>Imprimir Gráfico</title>
                                                <style>
                                                    body { text-align: center; margin: 20px; }
                                                    img { max-width: 100%; height: auto; }
                                                </style>
                                            </head>
                                            <body>
                                                <img src="${chartCanvas.toDataURL()}">
                                            </body>
                                        </html>
                                    `);
                                        printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function exportarGrafico(chartId) {
                                        const chartCanvas = document.getElementById(chartId);
                                        const link = document.createElement('a');
                                        link.download = 'grafico-ventas.png';
                                        link.href = chartCanvas.toDataURL();
                                        link.click();
                                    }

                                    function imprimirTabla() {
                                        const tabla = document.getElementById('tablaPedidos').outerHTML;
                                        const printWindow = window.open('', '_blank');
                                        printWindow.document.write(`
                                        <html>
                                            <head>
                                                <title>Imprimir Tabla de Pedidos</title>
                                                <style>
                                                    body { font-family: Arial, sans-serif; margin: 20px; }
                                                    table { width: 100%; border-collapse: collapse; }
                                                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                                                    th { background-color: #f2f2f2; }
                                                </style>
                                            </head>
                                            <body>
                                                <h2>Tabla de Pedidos</h2>
                                ${tabla}
                                            </body>
                                        </html>
                                    `);
                                        printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function exportarTabla() {
                                        // Implementar exportación a Excel
                                        alert('Exportando tabla a Excel...');
                                    }
        </script>
    </body>
</html>