<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("portalempleados");
        return;
    }
    
    if (session.getAttribute("nombreUsuario") != null) {
        pageContext.setAttribute("nombreUsuario", session.getAttribute("nombreUsuario"));
        pageContext.setAttribute("rolUsuario", session.getAttribute("rolUsuario"));
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Sistema de Gestión Comercial</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleDB.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts - Roboto -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <!-- AOS Animation -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/dashboard">
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
                            <h4 class="mb-0">Panel de Control</h4>
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
                        <div class="alert alert-success alert-dismissible fade show" role="alert" data-aos="fade-down">
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert" data-aos="fade-down">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <div class="row mb-4" data-aos="fade-up">
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="card-body">
                                    <h5 class="card-title">Clientes Activos</h5>
                                    <h2 class="card-text">9,580</h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> 5.6% este mes</p>
                                </div>
                                <div class="card-icon"><i class="fas fa-users"></i></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="card-body">
                                    <h5 class="card-title">Cotizaciones</h5>
                                    <h2 class="card-text">85</h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> 5.3% este mes</p>
                                </div>
                                <div class="card-icon"><i class="fas fa-file-invoice-dollar"></i></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="card-body">
                                    <h5 class="card-title">Ventas Totales</h5>
                                    <h2 class="card-text">$618.450.000</h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> 8.5% este mes</p>
                                </div>
                                <div class="card-icon"><i class="fas fa-chart-line"></i></div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="card-body">
                                    <h5 class="card-title">Productos</h5>
                                    <h2 class="card-text">3,000</h2>
                                    <p class="card-text text-success small"><i class="fas fa-arrow-up me-1"></i> 6.7% este mes</p>
                                </div>
                                <div class="card-icon"><i class="fas fa-boxes"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-4" data-aos="fade-up" data-aos-delay="100">
                        <div class="col-12">
                            <div class="stats-container">
                                <h5 class="mb-4">Acciones Rápidas</h5>
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <div class="quick-action">
                                            <a href="${pageContext.request.contextPath}/clientes?action=nuevo" class="quick-action text-decoration-none">
                                                <i class="fas fa-plus action-primary"></i>
                                                <h6 class="text-dark">Nuevo Cliente</h6>
                                                <small class="text-muted">Registrar nuevo cliente</small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="quick-action">
                                            <a href="${pageContext.request.contextPath}/cotizaciones?action=nuevo" class="quick-action text-decoration-none">
                                                <i class="fas fa-file-invoice action-accent"></i>
                                                <h6 class="text-dark">Crear Cotización</h6>
                                                <small class="text-muted">Generar nueva cotización</small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="quick-action">
                                            <a href="${pageContext.request.contextPath}/productos" class="quick-action text-decoration-none">
                                                <i class="fas fa-box action-success"></i>
                                                <h6 class="text-dark">Ver Productos</h6>
                                                <small class="text-muted">Verificar disponibilidad</small>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="quick-action">
                                            <a href="${pageContext.request.contextPath}/informes" class="quick-action text-decoration-none">
                                                <i class="fas fa-chart-pie action-danger"></i>
                                                <h6 class="text-dark">Ver Reportes</h6>
                                                <small class="text-muted">Analizar estadísticas</small>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" data-aos="fade-up" data-aos-delay="200">
                                    <div class="col-md-8 mb-4">
                                        <div class="stats-container">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h5 class="mb-0">Ventas Mensuales</h5>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="chartDropdown" data-bs-toggle="dropdown">
                                                        Últimos 12 meses
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="chartDropdown">
                                                        <li><a class="dropdown-item" href="#">Últimos 6 meses</a></li>
                                                        <li><a class="dropdown-item" href="#">Últimos 12 meses</a></li>
                                                        <li><a class="dropdown-item" href="#">Este año</a></li>
                                                        <li><a class="dropdown-item" href="#">Año anterior</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="chart-container">
                                                <canvas id="salesChart"></canvas>
                                            </div>
                                            <div class="chart-legend">
                                                <div class="legend-item">
                                                    <div class="legend-color" style="background-color: #cb9a28;"></div>
                                                    <small>Ventas Totales</small>
                                                </div>
                                                <div class="legend-item">
                                                    <div class="legend-color" style="background-color: #000000;"></div>
                                                    <small>Objetivo</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 mb-4">
                                        <div class="stats-container">
                                            <h5 class="mb-4">Actividad Reciente</h5>
                                            <div class="activity-item">
                                                <div class="activity-dot"></div>
                                                <div>
                                                    <h6>Nueva cotización</h6>
                                                    <p class="text-muted small">Constructora Andina - $28.450.000</p>
                                                    <small class="text-muted">Hace 15 minutos</small>
                                                </div>
                                            </div>
                                            <div class="activity-item">
                                                <div class="activity-dot"></div>
                                                <div>
                                                    <h6>Cliente registrado</h6>
                                                    <p class="text-muted small">Arq. María Pérez</p>
                                                    <small class="text-muted">Hace 2 horas</small>
                                                </div>
                                            </div>
                                            <div class="activity-item">
                                                <div class="activity-dot"></div>
                                                <div>
                                                    <h6>Venta realizada</h6>
                                                    <p class="text-muted small">Porcelanato Marmol - $9.200.000</p>
                                                    <small class="text-muted">Hoy, 10:45 AM</small>
                                                </div>
                                            </div>
                                            <div class="activity-item">
                                                <div class="activity-dot"></div>
                                                <div>
                                                    <h6>Stock actualizado</h6>
                                                    <p class="text-muted small">Cerámica Madrid 60x60</p>
                                                    <small class="text-muted">Ayer, 5:30 PM</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" data-aos="fade-up" data-aos-delay="300">
                                    <div class="col-12">
                                        <div class="stats-container">
                                            <div class="d-flex justify-content-between align-items-center mb-4">
                                                <h5 class="mb-0">Últimas Cotizaciones</h5>
                                                <a href="#" class="btn btn-sm btn-outline-custom">Ver Todas</a>
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>N° Cotización</th>
                                                            <th>Cliente</th>
                                                            <th>Fecha</th>
                                                            <th>Total</th>
                                                            <th>Estado</th>
                                                            <th>Acciones</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>COT-2025-00125</td>
                                                            <td>Constructora Andina S.A.</td>
                                                            <td>15/05/2025</td>
                                                            <td>$38.450.000</td>
                                                            <td><span class="badge bg-success">Aprobada</span></td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-secondary">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>COT-2025-00124</td>
                                                            <td>Arq. María Pérez</td>
                                                            <td>02/05/2025</td>
                                                            <td>$13.200.000</td>
                                                            <td><span class="badge bg-success">Aprobada</span></td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-secondary">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>COT-2025-00123</td>
                                                            <td>Ing. Carlos Gómez</td>
                                                            <td>12/05/2025</td>
                                                            <td>$9.750.000</td>
                                                            <td><span class="badge bg-danger">Pendiente</span></td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-secondary">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
                    <script>
                        // Inicializar animaciones
                        AOS.init({
                            duration: 800,
                            easing: 'ease-in-out',
                            once: true
                        });

                        // Script para toggle sidebar
                        document.getElementById('toggleSidebar').addEventListener('click', function () {
                            const sidebar = document.getElementById('sidebar');
                            const mainContent = document.getElementById('mainContent');

                            sidebar.classList.toggle('sidebar-collapsed');
                            mainContent.classList.toggle('main-content-expanded');
                        });

                        // Configuración del gráfico
                        document.addEventListener('DOMContentLoaded', function () {
                            const ctx = document.getElementById('salesChart');
                            if (ctx) {
                                const salesCtx = ctx.getContext('2d');

                                const months = ['May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic', 'Ene', 'Feb', 'Mar', 'Abr'];
                                const currentYearSales = [45, 52, 60, 58, 65, 72, 80, 78, 85, 90, 95, 110];
                                const targets = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105];

                                function formatMillions(value) {
                                    return '$' + value.toFixed(1) + 'M';
                                }

                                const salesChart = new Chart(salesCtx, {
                                    type: 'bar',
                                    data: {
                                        labels: months,
                                        datasets: [
                                            {
                                                label: 'Ventas Totales',
                                                data: currentYearSales,
                                                backgroundColor: '#cb9a28',
                                                borderColor: '#000000',
                                                borderWidth: 1,
                                                borderRadius: 4
                                            },
                                            {
                                                label: 'Objetivo',
                                                data: targets,
                                                type: 'line',
                                                borderColor: '#000000',
                                                backgroundColor: 'rgba(0, 0, 0, 0.1)',
                                                borderWidth: 2,
                                                pointBackgroundColor: '#000000',
                                                pointRadius: 4,
                                                fill: true
                                            }
                                        ]
                                    },
                                    options: {
                                        responsive: true,
                                        maintainAspectRatio: false,
                                        scales: {
                                            y: {
                                                beginAtZero: true,
                                                ticks: {callback: formatMillions},
                                                grid: {drawBorder: false}
                                            },
                                            x: {grid: {display: false}}
                                        },
                                        plugins: {
                                            legend: {display: false},
                                            tooltip: {
                                                callbacks: {
                                                    label: function (context) {
                                                        return context.dataset.label + ': ' + formatMillions(context.raw);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                });
                            }
                        });
                    </script>
                    </body>
                    </html>