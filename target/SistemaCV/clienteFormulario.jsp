<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("portalempleados");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title> Clientes Formulario| Sistema Empresarial</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleCF.css">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/clientes">
                            <i class="fas fa-users"></i> Clientes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-box"></i> Productos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice"></i> Cotizaciones
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice"></i> Pedidos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-invoice-dollar"></i> Facturación
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
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
                <nav class="navbar navbar-custom mb-4 d-flex">
                    <div class="container-fluid">
                        <div class="d-flex align-items-center">
                            <button class="toggle-sidebar me-3" id="toggleSidebar">
                                <i class="fas fa-bars"></i>
                            </button>
                            <h4 class="mb-0">Creacion de cliente</h4>
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
                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row justify-content-center">
                        <div class="col-lg-10">
                            <div class="card card-custom-form">
                                <div class="card-header card-header-custom">
                                    <h5 class="mb-0">
                                        <i class="fas ${empty cliente ? 'fa-user-plus' : 'fa-user-edit'} me-2"></i>
                                        ${empty cliente ? 'Registrar Nuevo Cliente' : 'Editar Información del Cliente'}
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form action="clientes" method="post" class="needs-validation" novalidate>
                                        <input type="hidden" name="action" value="guardar">
                                        <c:if test="${not empty cliente}">
                                            <input type="hidden" name="id" value="${cliente.id}">
                                        </c:if>

                                        <div class="form-section">
                                            <h6 class="section-title">
                                                <i class="fas fa-id-card me-2"></i>Información Básica
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                                           value="${cliente.nombre}" required>
                                                    <div class="invalid-feedback">
                                                        Por favor ingrese el nombre del cliente.
                                                    </div>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="apellido" class="form-label">Apellido <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="apellido" name="apellido" 
                                                           value="${cliente.apellido}" required>
                                                    <div class="invalid-feedback">
                                                        Por favor ingrese el apellido del cliente.
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="tipo_documento" class="form-label">Tipo de Documento</label>
                                                    <select class="form-select" id="tipo_documento" name="tipo_documento">
                                                        <option value="">Seleccionar...</option>
                                                        <option value="DNI" ${cliente.tipo_documento == 'DNI' ? 'selected' : ''}>DNI</option>
                                                        <option value="RUC" ${cliente.tipo_documento == 'RUC' ? 'selected' : ''}>RUC</option>
                                                        <option value="Carnet Extranjería" ${cliente.tipo_documento == 'Carnet Extranjería' ? 'selected' : ''}>Carnet Extranjería</option>
                                                        <option value="Pasaporte" ${cliente.tipo_documento == 'Pasaporte' ? 'selected' : ''}>Pasaporte</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="numero_documento" class="form-label">Número de Documento</label>
                                                    <input type="text" class="form-control" id="numero_documento" name="numero_documento" 
                                                           value="${cliente.numero_documento}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <h6 class="section-title">
                                                <i class="fas fa-address-book me-2"></i>Información de Contacto
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="email" class="form-label">Correo Electrónico</label>
                                                    <input type="email" class="form-control" id="correo_electronico" name="correo_electronico" 
                                                           value="${cliente.correo_electronico}">
                                                    <div class="form-text">Ejemplo: cliente@empresa.com</div>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="telefono" class="form-label">Teléfono/Celular</label>
                                                    <input type="tel" class="form-control" id="celular" name="celular" 
                                                           value="${cliente.celular}">
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-12 mb-3">
                                                    <label for="direccion" class="form-label">Dirección</label>
                                                    <textarea class="form-control" id="direccion" name="direccion" 
                                                              rows="2">${cliente.direccion}</textarea>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="ciudad" class="form-label">Ciudad</label>
                                                    <input type="text" class="form-control" id="ciudad" name="ciudad" 
                                                           value="${cliente.ciudad}">
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="pais" class="form-label">País</label>
                                                    <input type="text" class="form-control" id="pais" name="pais" 
                                                           value="${cliente.pais}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-section">
                                            <h6 class="section-title">
                                                <i class="fas fa-chart-line me-2"></i>Información Comercial
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="tipo_cliente" class="form-label">Tipo de Cliente <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="tipo_cliente" name="tipo_cliente" required>
                                                        <option value="">Seleccionar...</option>
                                                        <option value="Regular" ${cliente.tipo_cliente == 'Regular' ? 'selected' : ''}>Regular</option>
                                                        <option value="Premium" ${cliente.tipo_cliente == 'Premium' ? 'selected' : ''}>Premium</option>
                                                    </select>
                                                    <div class="invalid-feedback">
                                                        Por favor seleccione el tipo de cliente.
                                                    </div>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="estado" class="form-label">Estado <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="estado" name="estado" required>
                                                        <option value="">Seleccionar...</option>
                                                        <option value="Activo" ${cliente.estado == 'Activo' ? 'selected' : ''}>Activo</option>
                                                        <option value="Inactivo" ${cliente.estado == 'Inactivo' ? 'selected' : ''}>Inactivo</option>
                                                        <option value="Suspendido" ${cliente.estado == 'Suspendido' ? 'selected' : ''}>Suspendido</option>
                                                    </select>
                                                    <div class="invalid-feedback">
                                                        Por favor seleccione el estado del cliente.
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="limite_credito" class="form-label">Límite de Crédito</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text">$</span>
                                                        <input type="number" class="form-control" id="limite_credito" name="limite_credito" 
                                                               value="${cliente.limite_credito}" step="0.01" min="0">
                                                    </div>
                                                    <div class="form-text">Monto máximo de crédito autorizado</div>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="descuento" class="form-label">Descuento (%)</label>
                                                    <div class="input-group">
                                                        <input type="number" class="form-control" id="descuento" name="descuento" 
                                                               value="${cliente.descuento}" step="0.1" min="0" max="100">
                                                        <span class="input-group-text">%</span>
                                                    </div>
                                                    <div class="form-text">Porcentaje de descuento aplicable</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-section">
                                            <h6 class="section-title">
                                                <i class="fas fa-sticky-note me-2"></i>Información Adicional
                                            </h6>
                                            <div class="row">
                                                <div class="col-12 mb-3">
                                                    <label for="observaciones" class="form-label">Observaciones</label>
                                                    <textarea class="form-control" id="observaciones" name="observaciones" 
                                                              rows="3" placeholder="Notas adicionales sobre el cliente...">${cliente.observaciones}</textarea>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label for="idempleado" class="form-label">Empleado Asignado</label>
                                                    <input type="text" class="form-control" id="idempleado" name="idempleado" 
                                                           value="${cliente.idempleado}" placeholder="ID del empleado responsable">
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label for="fecha_registro" class="form-label">Fecha de Registro</label>
                                                    <input type="date" class="form-control" id="fecha_registro" name="fecha_registro" 
                                                           value="${cliente.fecha_registro}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="clientes" class="btn btn-outline-secondary">
                                                    <i class="fas fa-times me-2"></i>Cancelar
                                                </a>
                                                <div>
                                                    <button type="reset" class="btn btn-outline-warning me-2">
                                                        <i class="fas fa-redo me-2"></i>Limpiar
                                                    </button>
                                                    <button type="submit" class="btn btn-custom">
                                                        <i class="fas ${empty cliente ? 'fa-save' : 'fa-sync-alt'} me-2"></i>
                                                        ${empty cliente ? 'Registrar Cliente' : 'Actualizar Cliente'}
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="card card-custom-form mt-4">
                                <div class="card-body">
                                    <h6 class="mb-3"><i class="fas fa-info-circle me-2 text-primary"></i>Información Importante</h6>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <ul class="list-unstyled">
                                                <li class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-asterisk text-danger me-1"></i>
                                                        Campos marcados con asterisco (*) son obligatorios
                                                    </small>
                                                </li>
                                                <li class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-user me-1 text-primary"></i>
                                                        Los clientes Premium reciben beneficios exclusivos
                                                    </small>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <ul class="list-unstyled">
                                                <li class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-credit-card me-1 text-success"></i>
                                                        El límite de crédito define el monto máximo de compra
                                                    </small>
                                                </li>
                                                <li class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-percentage me-1 text-warning"></i>
                                                        El descuento se aplica automáticamente a las compras
                                                    </small>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toggleSidebar = document.querySelector('.toggle-sidebar');
                const sidebar = document.querySelector('.sidebar');
                const mainContent = document.querySelector('.main-content');

                if (toggleSidebar) {
                    toggleSidebar.addEventListener('click', function () {
                        sidebar.classList.toggle('d-none');
                        sidebar.classList.toggle('d-md-block');
                    });
                }

                // Validación de formulario
                const forms = document.querySelectorAll('.needs-validation');
                Array.from(forms).forEach(form => {
                    form.addEventListener('submit', event => {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
                // Auto-generar código de cliente para nuevos registros
                const nombreInput = document.getElementById('nombre');
                const apellidoInput = document.getElementById('apellido');
                if (nombreInput && apellidoInput && ${empty cliente}) {
                    function generarCodigo() {
                        const nombre = nombreInput.value.trim();
                        const apellido = apellidoInput.value.trim();
                        if (nombre && apellido) {
                            const codigo = (nombre.substring(0, 3) + apellido.substring(0, 3)).toUpperCase();
                            // Aquí podrías asignar el código a un campo hidden si lo necesitas
                            console.log('Código sugerido:', codigo);
                        }
                    }

                    nombreInput.addEventListener('blur', generarCodigo);
                    apellidoInput.addEventListener('blur', generarCodigo);
                }

                // Mostrar/ocultar campos según tipo de cliente
                const tipoClienteSelect = document.getElementById('tipo_cliente');
                const limiteCreditoGroup = document.getElementById('limite_credito').closest('.mb-3');
                const descuentoGroup = document.getElementById('descuento').closest('.mb-3');
                function toggleCamposPremium() {
                    if (tipoClienteSelect.value === 'Premium') {
                        limiteCreditoGroup.style.display = 'block';
                        descuentoGroup.style.display = 'block';
                    } else {
                        limiteCreditoGroup.style.display = 'block';
                        descuentoGroup.style.display = 'block';
                        // Para mostrar siempre estos campos, puedes comentar las líneas anteriores
                        // y descomentar las siguientes si quieres ocultarlos para Regular:
                        // limiteCreditoGroup.style.display = 'none';
                        // descuentoGroup.style.display = 'none';
                    }
                }

                if (tipoClienteSelect) {
                    tipoClienteSelect.addEventListener('change', toggleCamposPremium);
                    toggleCamposPremium(); // Ejecutar al cargar la página
                }
            }
            );
        </script>
    </body>
</html>