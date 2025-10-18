<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, portalempleado.modelos.*, java.util.Map, java.time.format.DateTimeFormatter" %>
<%
    List<InformeVentas> ventas = (List<InformeVentas>) request.getAttribute("ventas");
    Map<String, Object> estadisticas = (Map<String, Object>) request.getAttribute("estadisticas");
    
    java.time.LocalDate fechaInicio = (java.time.LocalDate) request.getAttribute("fechaInicio");
    java.time.LocalDate fechaFin = (java.time.LocalDate) request.getAttribute("fechaFin");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // Calcular totales
    Number totalIngresos = (Number) estadisticas.getOrDefault("totalIngresos", 0);
    Number promedioVenta = (Number) estadisticas.getOrDefault("promedioVenta", 0);
    Number totalVentas = (Number) estadisticas.getOrDefault("totalVentas", 0);
    Number ventaMaxima = (Number) estadisticas.getOrDefault("ventaMaxima", 0);
    Number ventaMinima = (Number) estadisticas.getOrDefault("ventaMinima", 0);
    
    Number totalEfectivo = (Number) estadisticas.getOrDefault("totalEfectivo", 0);
    Number totalTarjeta = (Number) estadisticas.getOrDefault("totalTarjeta", 0);
    Number totalTransferencia = (Number) estadisticas.getOrDefault("totalTransferencia", 0);
    Number totalCheque = (Number) estadisticas.getOrDefault("totalCheque", 0);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Informe de Ventas | Sistema Comercial</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleINVE.css">
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
                    <!-- Mensajes -->
                    <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="alert alert-<%= request.getAttribute("tipoMensaje") %> alert-dismissible fade show" role="alert">
                        <%= request.getAttribute("mensaje") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0"><i class="fas fa-shopping-cart me-2"></i> Informe Detallado de Ventas</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/informes" class="btn btn-outline-secondary me-2">
                                <i class="fas fa-arrow-left me-2"></i>Volver
                            </a>
                            <button class="btn btn-custom" onclick="exportarVentas()">
                                <i class="fas fa-file-export me-2"></i>Exportar
                            </button>
                        </div>
                    </div>

                    <!-- Filtros -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="date-range-picker">
                                <h5 class="mb-3"><i class="fas fa-calendar-alt me-2"></i> Período Seleccionado</h5>
                                <form method="get" action="${pageContext.request.contextPath}/informes/ventas">
                                    <div class="row">
                                        <div class="col-md-3 mb-2">
                                            <label for="fechaInicio" class="form-label">Fecha Inicio</label>
                                            <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" 
                                                   value="<%= fechaInicio.format(formatter) %>">
                                        </div>
                                        <div class="col-md-3 mb-2">
                                            <label for="fechaFin" class="form-label">Fecha Fin</label>
                                            <input type="date" class="form-control" id="fechaFin" name="fechaFin"
                                                   value="<%= fechaFin.format(formatter) %>">
                                        </div>
                                        <div class="col-md-3 d-flex align-items-end mb-2">
                                            <button type="submit" class="btn btn-custom w-100">
                                                <i class="fas fa-filter me-2"></i>Actualizar
                                            </button>
                                        </div>
                                        <div class="col-md-3 d-flex align-items-end mb-2">
                                            <a href="${pageContext.request.contextPath}/informes/ventas" class="btn btn-outline-secondary w-100">
                                                <i class="fas fa-sync me-2"></i>Restablecer
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Tarjetas de resumen -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom report-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="card-title text-success">Total Ventas</h5>
                                            <h3 class="text-success">$<%= String.format("%,d", totalIngresos.longValue()) %></h3>
                                            <p class="card-text">Ingresos totales</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-money-bill-wave"></i>
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
                                            <h5 class="card-title text-primary">Transacciones</h5>
                                            <h3 class="text-primary"><%= totalVentas %></h3>
                                            <p class="card-text">Ventas realizadas</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-receipt"></i>
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
                                            <h5 class="card-title text-warning">Promedio</h5>
                                            <h3 class="text-warning">$<%= String.format("%,d", promedioVenta.longValue()) %></h3>
                                            <p class="card-text">Por transacción</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-chart-bar"></i>
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
                                            <h5 class="card-title text-info">Venta Máxima</h5>
                                            <h3 class="text-info">$<%= String.format("%,d", ventaMaxima.longValue()) %></h3>
                                            <p class="card-text">Mayor transacción</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-trophy"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Gráficos -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Distribución por Método de Pago</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="paymentMethodChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Tendencia de Ventas</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="salesTrendChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de Ventas Detalladas -->
                    <div class="card card-custom mb-4">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">Detalle de Ventas</h5>
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
                                <table class="table table-hover" id="tablaVentas">
                                    <thead>
                                        <tr>
                                            <th>N° Factura</th>
                                            <th>Fecha</th>
                                            <th>Cliente</th>
                                            <th>Vendedor</th>
                                            <th>Producto</th>
                                            <th>Cantidad</th>
                                            <th>Precio Unit.</th>
                                            <th>Total</th>
                                            <th>Método Pago</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (ventas != null && !ventas.isEmpty()) { 
                                        for (InformeVentas venta : ventas) { %>
                                        <tr>
                                            <td><%= venta.getNumeroFactura() %></td>
                                            <td><%= venta.getFecha().format(displayFormatter) %></td>
                                            <td><%= venta.getCliente() %></td>
                                            <td><%= venta.getVendedor() %></td>
                                            <td><%= venta.getProducto() %></td>
                                            <td><%= venta.getCantidad() %></td>
                                            <td>$<%= String.format("%,d", venta.getPrecioUnitario().longValue()) %></td>
                                            <td>$<%= String.format("%,d", venta.getTotalVenta().longValue()) %></td>
                                            <td>
                                                <span class="badge
                                                      <%= venta.getMetodoPago().equals("EFECTIVO") ? "bg-success" : 
                                                          venta.getMetodoPago().equals("TARJETA_CREDITO") ? "bg-primary" : 
                                                          venta.getMetodoPago().equals("TRANSFERENCIA") ? "bg-info" : "bg-warning" %>">
                                                    <%= venta.getMetodoPago() %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge
                                                      <%= venta.getEstado().equals("COMPLETADA") ? "bg-success" : 
                                                    venta.getEstado().equals("PENDIENTE") ? "bg-warning text-dark" : "bg-danger" %>">
                                                    <%= venta.getEstado() %>
                                                </span>
                                            </td>
                                        </tr>
                                        <% } 
                                    } else { %>
                                        <tr>
                                            <td colspan="10" class="text-center">No hay ventas en el período seleccionado</td>
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


                                    // Gráfico de Métodos de Pago
                                    const paymentCtx = document.getElementById('paymentMethodChart').getContext('2d');
                                    const paymentChart = new Chart(paymentCtx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: ['Efectivo', 'Tarjeta Crédito', 'Transferencia', 'Cheque'],
                                            datasets: [{
                                                    data: [
                                    <%= totalEfectivo.longValue() %>,
                                    <%= totalTarjeta.longValue() %>,
                                    <%= totalTransferencia.longValue() %>,
                                    <%= totalCheque.longValue() %>
                                                    ],
                                                    backgroundColor: [
                                                        'rgba(40, 167, 69, 0.7)',
                                                        'rgba(0, 123, 255, 0.7)',
                                                        'rgba(23, 162, 184, 0.7)',
                                                        'rgba(255, 193, 7, 0.7)'
                                                    ],
                                                    borderColor: [
                                                        'rgba(40, 167, 69, 1)',
                                                        'rgba(0, 123, 255, 1)',
                                                        'rgba(23, 162, 184, 1)',
                                                        'rgba(255, 193, 7, 1)'
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
                                                },
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

                                    // Gráfico de Tendencia de Ventas (simulado)
                                    const trendCtx = document.getElementById('salesTrendChart').getContext('2d');
                                    const trendChart = new Chart(trendCtx, {
                                        type: 'line',
                                        data: {
                                            labels: ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'],
                                            datasets: [{
                                                    label: 'Ventas Semanales',
                                                    data: [12000000, 15000000, 18000000, 21000000],
                                                    backgroundColor: 'rgba(203, 154, 40, 0.2)',
                                                    borderColor: 'rgba(203, 154, 40, 1)',
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
                                                    beginAtZero: true,
                                                    ticks: {
                                                        callback: function (value) {
                                                            return '$' + (value / 1000000).toFixed(1) + 'M';
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    // Funciones de exportación
                                    function exportarVentas() {
                                        const fechaInicio = document.getElementById('fechaInicio').value;
                                        const fechaFin = document.getElementById('fechaFin').value;
                                        window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=ventas&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                    }

                                    function imprimirTabla() {
                                        const tabla = document.getElementById('tablaVentas').outerHTML;
                                        const printWindow = window.open('', '_blank');
                                        printWindow.document.write(`
                                        <html>
                                            <head>
                                                <title>Imprimir Informe de Ventas</title>
                                                <style>
                                                    body { font-family: Arial, sans-serif; margin: 20px; }
                                                    table { width: 100%; border-collapse: collapse; font-size: 12px; }
                                                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                                                    th { background-color: #f2f2f2; }
                                                    .badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; }
                                                </style>
                                            </head>
                                            <body>
                                                <h2>Informe de Ventas</h2>
                                                <p>Período: <%= fechaInicio.format(displayFormatter) %> - <%= fechaFin.format(displayFormatter) %></p>
                                ${tabla}
                                            </body>
                                        </html>
                                    `);
                                                            printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function exportarTabla() {
                                        alert('Exportando informe de ventas a Excel...');
                                    }
        </script>
    </body>
</html>