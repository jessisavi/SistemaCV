<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, portalempleado.modelos.*, java.util.Map, java.time.format.DateTimeFormatter" %>
<%
    List<InformePedidos> pedidos = (List<InformePedidos>) request.getAttribute("pedidos");
    
    java.time.LocalDate fechaInicio = (java.time.LocalDate) request.getAttribute("fechaInicio");
    java.time.LocalDate fechaFin = (java.time.LocalDate) request.getAttribute("fechaFin");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter displayFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // Calcular estadísticas
    long totalPedidos = pedidos != null ? pedidos.size() : 0;
    long pedidosCompletados = pedidos != null ? pedidos.stream().filter(p -> "COMPLETADA".equals(p.getEstado())).count() : 0;
    long pedidosPendientes = pedidos != null ? pedidos.stream().filter(p -> "PENDIENTE".equals(p.getEstado())).count() : 0;
    long pedidosCancelados = pedidos != null ? pedidos.stream().filter(p -> "CANCELADA".equals(p.getEstado())).count() : 0;
    
    double totalValor = pedidos != null ? pedidos.stream().mapToDouble(p -> p.getTotal().doubleValue()).sum() : 0;
    double promedioPedido = totalPedidos > 0 ? totalValor / totalPedidos : 0;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Informe de Pedidos | Sistema Comercial</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleINPE.css">
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
                        <h2 class="mb-0"><i class="fas fa-clipboard-list me-2"></i> Informe Detallado de Pedidos</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/informes" class="btn btn-outline-secondary me-2">
                                <i class="fas fa-arrow-left me-2"></i>Volver
                            </a>
                            <button class="btn btn-custom" onclick="exportarPedidos()">
                                <i class="fas fa-file-export me-2"></i>Exportar
                            </button>
                        </div>
                    </div>

                    <!-- Filtros -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="date-range-picker">
                                <h5 class="mb-3"><i class="fas fa-calendar-alt me-2"></i> Período Seleccionado</h5>
                                <form method="get" action="${pageContext.request.contextPath}/informes/pedidos">
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
                                            <a href="${pageContext.request.contextPath}/informes/pedidos" class="btn btn-outline-secondary w-100">
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
                                            <h5 class="card-title text-primary">Total Pedidos</h5>
                                            <h3 class="text-primary"><%= totalPedidos %></h3>
                                            <p class="card-text">Pedidos registrados</p>
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
                                            <h5 class="card-title text-success">Valor Total</h5>
                                            <h3 class="text-success">$<%= String.format("%,d", (long)totalValor) %></h3>
                                            <p class="card-text">Valor total pedidos</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-dollar-sign"></i>
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
                                            <h5 class="card-title text-warning">Tasa Completación</h5>
                                            <h3 class="text-warning">
                                                <% 
                                                    double tasaCompletacion = totalPedidos > 0 ? 
                                                        (pedidosCompletados * 100.0 / totalPedidos) : 0;
                                                %>
                                                <%= String.format("%.1f", tasaCompletacion) %>%
                                            </h3>
                                            <p class="card-text">Pedidos completados</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-check-circle"></i>
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
                                            <h5 class="card-title text-info">Promedio</h5>
                                            <h3 class="text-info">$<%= String.format("%,d", (long)promedioPedido) %></h3>
                                            <p class="card-text">Por pedido</p>
                                        </div>
                                        <div class="report-icon">
                                            <i class="fas fa-calculator"></i>
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
                                    <h5 class="mb-0">Estado de Pedidos</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="ordersStatusChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-custom">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">Distribución por Cliente</h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="clientDistributionChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de Pedidos Detallados -->
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
                                            <th>Fecha</th>
                                            <th>Cliente</th>
                                            <th>Vendedor</th>
                                            <th>Productos</th>
                                            <th>Unidades</th>
                                            <th>Total</th>
                                            <th>Estado</th>
                                            <th>Notas</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (pedidos != null && !pedidos.isEmpty()) { 
                                        for (InformePedidos pedido : pedidos) { %>
                                        <tr>
                                            <td><%= pedido.getNumeroPedido() %></td>
                                            <td><%= pedido.getFecha().format(displayFormatter) %></td>
                                            <td><%= pedido.getCliente() %></td>
                                            <td><%= pedido.getVendedor() %></td>
                                            <td><%= pedido.getCantidadProductos() %></td>
                                            <td><%= pedido.getTotalUnidades() %></td>
                                            <td>$<%= String.format("%,d", pedido.getTotal().longValue()) %></td>
                                            <td>
                                                <span class="badge
                                                      <%= pedido.getEstado().equals("COMPLETADA") ? "bg-success" : 
                                                    pedido.getEstado().equals("PENDIENTE") ? "bg-warning text-dark" : "bg-danger" %>">
                                                    <%= pedido.getEstado() %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if (pedido.getNotas() != null && !pedido.getNotas().isEmpty()) { %>
                                                <i class="fas fa-sticky-note text-muted" title="<%= pedido.getNotas() %>"></i>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } 
                                    } else { %>
                                        <tr>
                                            <td colspan="9" class="text-center">No hay pedidos en el período seleccionado</td>
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

                                    // Gráfico de Estados de Pedidos
                                    const statusCtx = document.getElementById('ordersStatusChart').getContext('2d');
                                    const statusChart = new Chart(statusCtx, {
                                        type: 'doughnut',
                                        data: {
                                            labels: ['Completados', 'Pendientes', 'Cancelados'],
                                            datasets: [{
                                                    data: [
                                            <%= pedidosCompletados %>,
                                            <%= pedidosPendientes %>,
                                            <%= pedidosCancelados %>
                                                    ],
                                                    backgroundColor: [
                                                        'rgba(40, 167, 69, 0.7)',
                                                        'rgba(255, 193, 7, 0.7)',
                                                        'rgba(220, 53, 69, 0.7)'
                                                    ],
                                                    borderColor: [
                                                        'rgba(40, 167, 69, 1)',
                                                        'rgba(255, 193, 7, 1)',
                                                        'rgba(220, 53, 69, 1)'
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

                                    // Gráfico de Distribución por Cliente (simulado)
                                    const clientCtx = document.getElementById('clientDistributionChart').getContext('2d');
                                    const clientChart = new Chart(clientCtx, {
                                        type: 'bar',
                                        data: {
                                            labels: ['Constructora Andina', 'Arq. María Pérez', 'Ing. Carlos Gómez', 'Decoraciones Laura', 'Arq. Abud Zahid'],
                                            datasets: [{
                                                    label: 'Pedidos por Cliente',
                                                    data: [5, 3, 2, 4, 3],
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
                                                        stepSize: 1
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    // Funciones de exportación
                                    function exportarPedidos() {
                                        const fechaInicio = document.getElementById('fechaInicio').value;
                                        const fechaFin = document.getElementById('fechaFin').value;
                                        window.location.href = '${pageContext.request.contextPath}/informes/exportar?tipo=pedidos&formato=excel&fechaInicio=' + fechaInicio + '&fechaFin=' + fechaFin;
                                    }

                                    function imprimirTabla() {
                                        const tabla = document.getElementById('tablaPedidos').outerHTML;
                                        const printWindow = window.open('', '_blank');
                                        printWindow.document.write(`
                                        <html>
                                            <head>
                                                <title>Imprimir Informe de Pedidos</title>
                                                <style>
                                                    body { font-family: Arial, sans-serif; margin: 20px; }
                                                    table { width: 100%; border-collapse: collapse; font-size: 12px; }
                                                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                                                    th { background-color: #f2f2f2; }
                                                    .badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; }
                                                </style>
                                            </head>
                                            <body>
                                                <h2>Informe de Pedidos</h2>
                                                <p>Período: <%= fechaInicio.format(displayFormatter) %> - <%= fechaFin.format(displayFormatter) %></p>
                                ${tabla}
                                            </body>
                                        </html>
                                    `);
                                        printWindow.document.close();
                                        printWindow.print();
                                    }

                                    function exportarTabla() {
                                        alert('Exportando informe de pedidos a Excel...');
                                    }
        </script>
    </body>
</html>