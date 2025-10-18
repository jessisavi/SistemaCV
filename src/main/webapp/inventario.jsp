<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<<%@ page import="portalempleadosmodelo.Producto" %>
<%@ page import="portalempleadosmodelo.Categoria" %>
<%@ page import="java.util.List" %>
<%
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inventario | Bodega de Logistica Stylish Home</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleIN.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar d-none d-md-block">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/inventario">
                            <i class="fas fa-boxes"></i> Productos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fa-solid fa-rotate"></i> Actualización masiva
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fa-solid fa-location-dot"></i> Ubicación en Almacén
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fa-solid fa-dolly"></i> Productos reservados
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fa-solid fa-truck"></i> Despachos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-chart-bar"></i> Reportes de importación
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
            <div class="main-content flex-grow-1">
                <nav class="navbar navbar-expand-lg navbar-custom mb-4">
                    <div class="container-fluid">
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav me-auto">
                                <li class="nav-item">
                                    <a class="nav-link" href="#"><i class="fas fa-bars me-2"></i> Menú</a>
                                </li>
                            </ul>
                            <div class="dropdown me-3">
                                <button class="btn btn-light dropdown-toggle" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                                    <i class="fas fa-bell"></i>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">5</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationsDropdown">
                                    <li><h6 class="dropdown-header">Notificaciones</h6></li>
                                    <li><a class="dropdown-item" href="#">Cantidad actualizada - Porcelanato mármol</a></li>
                                    <li><a class="dropdown-item" href="#">Stock bajo en cerámicas madrid</a></li>
                                    <li><a class="dropdown-item" href="#">Ingreso a almacén de importación IMP-2025-53978</a></li>
                                    <li><a class="dropdown-item" href="#">Inventario actualizado correctamente</a></li>
                                    <li><a class="dropdown-item" href="#">Producto nuevo creado correctamente</a></li>
                                </ul>
                            </div>
                            <div class="d-flex align-items-center">
                                <div class="user-avatar me-2">AD</div>
                                <span class="me-3">Gestor de logística</span>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-custom">
                                    <i class="fas fa-sign-out-alt"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid">
                    <% if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>
                    <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0"><i class="fas fa-boxes me-2"></i> Gestión de Inventario</h2>
                        <div>
                            <a href="${pageContext.request.contextPath}/inventario?action=nuevo" class="btn btn-custom me-2">
                                <i class="fas fa-plus me-2"></i>Nuevo Producto
                            </a>
                            <button class="btn btn-outline-custom">
                                <i class="fas fa-file-export me-2"></i>Exportar
                            </button>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Total Productos</h5>
                                    <h2 class="card-text"><%= productos != null ? productos.size() : 0 %></h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Stock Bajo</h5>
                                    <h2 class="card-text">60</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Importaciones en transito</h5>
                                    <h2 class="card-text">180</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body">
                                    <h5 class="card-title">Nuevos Ingresos</h5>
                                    <h2 class="card-text">56</h2>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            <h5 class="mb-0">Productos en Inventario</h5>
                            <div class="d-flex">
                                <form method="get" action="${pageContext.request.contextPath}/inventario" class="d-flex me-3">
                                    <div class="search-box me-2">
                                        <i class="fas fa-search"></i>
                                        <input type="text" name="busqueda" class="form-control" placeholder="Buscar productos..." 
                                               style="width: 250px;" value="${param.busqueda}">
                                    </div>
                                    <button type="submit" class="btn btn-custom">Buscar</button>
                                </form>
                                <form method="get" action="${pageContext.request.contextPath}/inventario" class="d-flex">
                                    <select class="form-select me-2" name="categoria" style="width: 180px;" onchange="this.form.submit()">
                                        <option value="">Todas las categorías</option>
                                        <c:forEach var="categoria" items="${categorias}">
                                            <option value="${categoria.id}" ${param.categoria == categoria.id ? 'selected' : ''}>
                                                ${categoria.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <a href="${pageContext.request.contextPath}/inventario" class="btn btn-outline-secondary">Limpiar</a>
                                </form>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="productsTable">
                                    <thead>
                                        <tr>
                                            <th>Producto</th>
                                            <th>Código</th>
                                            <th>Categoría</th>
                                            <th>Precio</th>
                                            <th>Stock</th>
                                            <th>Ubicación</th>
                                            <th>Proveedor</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (productos != null && !productos.isEmpty()) { 
                                            for (Producto producto : productos) { 
                                                String stockClass = "";
                                                if (producto.getStock() > 200) {
                                                    stockClass = "stock-high";
                                                } else if (producto.getStock() > 50) {
                                                    stockClass = "stock-medium";
                                                } else {
                                                    stockClass = "stock-low";
                                                }
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/images/<%= producto.getImagen() != null ? producto.getImagen() : "default.jpg" %>" 
                                                         alt="<%= producto.getNombre() %>" class="product-img me-3">
                                                    <div>
                                                        <h6 class="mb-0"><%= producto.getNombre() %></h6>
                                                        <small class="text-muted">Color: <%= producto.getColor() %></small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><%= producto.getCodigo() %></td>
                                            <td>
                                                <span class="badge badge-category <%= getCategoryClass(producto.getCategoriaNombre()) %>">
                                                    <%= producto.getCategoriaNombre() != null ? producto.getCategoriaNombre() : "Sin categoría" %>
                                                </span>
                                            </td>
                                            <td>$<%= String.format("%,.0f", producto.getPrecio()) %> M<sup>2</sup></td>
                                            <td class="<%= stockClass %>">
                                                <%= producto.getStock() %> <small class="text-muted">Caja</small>
                                            </td>
                                            <td><%= producto.getUbicacion() != null ? producto.getUbicacion() : "Sin ubicación" %></td>
                                            <td><%= producto.getProveedorNombre() != null ? producto.getProveedorNombre() : "Sin proveedor" %></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/inventario?action=ver&id=<%= producto.getId() %>" 
                                                   class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/inventario?action=editar&id=<%= producto.getId() %>" 
                                                   class="btn btn-sm btn-outline-secondary ms-1">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/inventario" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="eliminar">
                                                    <input type="hidden" name="id" value="<%= producto.getId() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger ms-1" 
                                                            onclick="return confirm('¿Está seguro de eliminar este producto?')">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } 
                                    } else { %>
                                        <tr>
                                            <td colspan="8" class="text-center">No hay productos registrados</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center mt-3">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" tabindex="-1">Anterior</a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item"><a class="page-link" href="#">4</a></li>
                                    <li class="page-item"><a class="page-link" href="#">5</a></li>
                                    <li class="page-item"><a class="page-link" href="#">6</a></li>
                                    <li class="page-item"><a class="page-link" href="#">7</a></li>
                                    <li class="page-item"><a class="page-link" href="#">...</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Siguiente</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                // Filtro de búsqueda
                                                                document.getElementById('searchInput').addEventListener('input', function () {
                                                                    const filter = this.value.toLowerCase();
                                                                    const rows = document.querySelectorAll('#productsTable tbody tr');

                                                                    rows.forEach(row => {
                                                                        const text = row.textContent.toLowerCase();
                                                                        row.style.display = text.includes(filter) ? '' : 'none';
                                                                    });
                                                                });

                                                                // Filtro por categorías
                                                                document.getElementById('categoryFilter').addEventListener('change', function () {
                                                                    const filter = this.value.toLowerCase();
                                                                    const rows = document.querySelectorAll('#productsTable tbody tr');

                                                                    rows.forEach(row => {
                                                                        const category = row.cells[2].textContent.toLowerCase();
                                                                        if (filter === '' || category.includes(filter)) {
                                                                            row.style.display = '';
                                                                        } else {
                                                                            row.style.display = 'none';
                                                                        }
                                                                    });
                                                                });
        </script>
    </body>
</html>

<%!
    // Método helper para obtener clase CSS según categoría
    private String getCategoryClass(String categoria) {
        if (categoria == null) return "ceramica";
        
        switch(categoria.toLowerCase()) {
            case "cerámica piso":
            case "cerámica pared":
                return "ceramica";
            case "porcelanato":
                return "porcelanato";
            case "baños":
                return "banos";
            case "cocinas":
                return "cocinas";
            case "piedra natural":
                return "piedra";
            case "fachaleta":
                return "fachaleta";
            default:
                return "ceramica";
        }
    }
%>