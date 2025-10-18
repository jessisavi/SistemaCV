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
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Administración de Roles | Sistema de Empleados</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleRO.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex">
            <div class="sidebar d-none d-md-block" style="width: 250px;">
                <div style="text-align: center;">
                    <img src="${pageContext.request.contextPath}/images/StylishHome.jpg" 
                         alt="Imagen Corporativa" style="height: 14rem;">
                </div> 
                <ul class="nav flex-column px-3">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/rolessv">
                            <i class="fas fa-users-cog"></i> Gestión de Roles
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-users"></i> Empleados
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
                <nav class="navbar navbar-expand-lg navbar-custom mb-4 rounded">
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
                            <div class="d-flex align-items-center">
                                <c:choose>
                                    <c:when test="${not empty nombreUsuario}">
                                        <div class="user-avatar me-2">${nombreUsuario.charAt(0)}</div>
                                        <span class="me-3">${nombreUsuario} (${rolUsuario})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar me-2">U</div>
                                        <span class="me-3">Usuario (Rol)</span>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-custom">
                                    <i class="fas fa-sign-out-alt"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>
                <div class="container-fluid">
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <c:choose>
                                <c:when test="${success == 'create'}">Rol creado exitosamente</c:when>
                                <c:when test="${success == 'update'}">Rol actualizado exitosamente</c:when>
                                <c:when test="${success == 'delete'}">Rol eliminado exitosamente</c:when>
                            </c:choose>
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
                        <h2 class="mb-0">Gestión de Roles de Empleados</h2>
                        <button class="btn btn-custom" data-bs-toggle="modal" data-bs-target="#addRoleModal">
                            <i class="fas fa-plus me-2"></i>Nuevo Rol
                        </button>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body text-center">
                                    <i class="fas fa-user-tie fa-3x text-accent mb-3"></i>
                                    <h5 class="card-title">Gerente</h5>
                                    <h2 class="card-text">6</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body text-center">
                                    <i class="fas fa-store-alt fa-3x text-accent mb-3"></i>
                                    <h5 class="card-title">Jefe de tienda</h5>
                                    <h2 class="card-text">34</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body text-center">
                                    <i class="fas fa-users fa-3x text-accent mb-3"></i>
                                    <h5 class="card-title">Empleados</h5>
                                    <h2 class="card-text">2162</h2>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom">
                                <div class="card-body text-center">
                                    <i class="fas fa-chart-pie fa-3x text-accent mb-3"></i>
                                    <h5 class="card-title">Total</h5>
                                    <h2 class="card-text">${not empty totalUsuarios ? totalUsuarios : 0}</h2>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card card-custom">
                        <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Lista de Roles (${not empty totalRoles ? totalRoles : 0})</h5>
                            <div class="input-group" style="width: 300px;">
                                <input type="text" class="form-control" placeholder="Buscar roles...">
                                <button class="btn btn-outline-secondary" type="button">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Nombre del Rol</th>
                                            <th>Descripción</th>
                                            <th>N° de Usuarios</th>
                                            <th>Permisos</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="rol" items="${roles}">
                                            <tr>
                                                <td><span class="badge bg-primary">${rol.nombre}</span></td>
                                                <td>${rol.descripcion}</td>
                                                <td>${rol.numeroUsuarios}</td>
                                                <td>${rol.permisos != null ? rol.permisos.size() : 0}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/rolessv?action=editar&id=${rol.id}" class="btn btn-sm btn-outline-secondary">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/rolessv?action=eliminar&id=${rol.id}" 
                                                       class="btn btn-sm btn-outline-danger ms-1"
                                                       onclick="return confirm('¿Está seguro de eliminar este rol?')">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty roles}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-4">
                                                    <i class="fas fa-info-circle fa-2x mb-2"></i>
                                                    <p>No hay roles registrados</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="addRoleModal" tabindex="-1" aria-labelledby="addRoleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addRoleModalLabel">Crear Nuevo Rol</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/rolessv" method="post">
                        <input type="hidden" name="action" value="crear">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="roleName" class="form-label">Nombre del Rol *</label>
                                        <input type="text" class="form-control" id="roleName" name="nombre" placeholder="Ej: Auditor" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="roleDescription" class="form-label">Descripción *</label>
                                        <textarea class="form-control" id="roleDescription" name="descripcion" rows="1" placeholder="Descripción del rol" required></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Permisos</label>
                                <div class="border p-3 rounded" style="max-height: 300px; overflow-y: auto;">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="registrar_empleado" id="perm1">
                                                <label class="form-check-label" for="perm1">Registrar Empleado</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="asignacion_roles" id="perm2">
                                                <label class="form-check-label" for="perm2">Asignación de roles</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="modificar_roles" id="perm3">
                                                <label class="form-check-label" for="perm3">Modificar roles</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="eliminar_empleado" id="perm4">
                                                <label class="form-check-label" for="perm4">Eliminar empleado</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="registro_transacciones" id="perm5">
                                                <label class="form-check-label" for="perm5">Registro de transacciones</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_informes" id="perm6">
                                                <label class="form-check-label" for="perm6">Gestión de informes</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="analisis_datos" id="perm7">
                                                <label class="form-check-label" for="perm7">Análisis de datos</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="reportes_financieros" id="perm8">
                                                <label class="form-check-label" for="perm8">Reportes financieros</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="registro_producto" id="perm9">
                                                <label class="form-check-label" for="perm9">Registro de producto</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="modificacion_productos" id="perm10">
                                                <label class="form-check-label" for="perm10">Modificación de productos</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="eliminar_productos" id="perm11">
                                                <label class="form-check-label" for="perm11">Eliminar producto</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_compra" id="perm12">
                                                <label class="form-check-label" for="perm12">Gestión de compra</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="rrhh" id="perm13">
                                                <label class="form-check-label" for="perm13">RRHH</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_presupuestal" id="perm14">
                                                <label class="form-check-label" for="perm14">Gestión presupuestal</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_ventas" id="perm15">
                                                <label class="form-check-label" for="perm15">Gestión de ventas</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_administrativa" id="perm16">
                                                <label class="form-check-label" for="perm16">Gestión Administrativa</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_cotizaciones" id="perm17">
                                                <label class="form-check-label" for="perm17">Gestión de cotizaciones</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="checkbox" name="permisos" value="gestion_pedidos" id="perm18">
                                                <label class="form-check-label" for="perm18">Gestión de pedidos</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-custom">Guardar Rol</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                           document.addEventListener('DOMContentLoaded', function () {
                                                               const navbarToggler = document.querySelector('.navbar-toggler');
                                                               const sidebar = document.querySelector('.sidebar');

                                                               if (navbarToggler && sidebar) {
                                                                   navbarToggler.addEventListener('click', function () {
                                                                       sidebar.classList.toggle('d-md-block');
                                                                   });
                                                               }

                                                               document.addEventListener('click', function (event) {
                                                                   if (window.innerWidth < 768) {
                                                                       const isClickInsideSidebar = sidebar.contains(event.target);
                                                                       const isClickInsideToggler = navbarToggler.contains(event.target);

                                                                       if (!isClickInsideSidebar && !isClickInsideToggler && sidebar.classList.contains('d-md-block')) {
                                                                           sidebar.classList.remove('d-md-block');
                                                                       }
                                                                   }
                                                               });
                                                           });
        </script>
    </body>
</html>