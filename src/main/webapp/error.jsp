<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error del Sistema | Portal de Empleados</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StyleER.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="error-container">
            <div class="error-header">
                <i class="fas fa-exclamation-triangle error-icon"></i>
                <h2>Error del Sistema</h2>
                <p class="mb-0">Ha ocurrido un error inesperado en la aplicación</p>
            </div>

            <div class="error-body">
                <%
                    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
                    String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
                    String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
                    String servletName = (String) request.getAttribute("jakarta.servlet.error.servlet_name");
                    Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                    
                    String customError = (String) request.getAttribute("error");
                    String customMessage = (String) request.getAttribute("message");
                    
                    Throwable ex = throwable != null ? throwable : (Throwable) request.getAttribute("jakarta.servlet.error.exception");
    
                    String mainMessage = "Ha ocurrido un error inesperado. Por favor, intente nuevamente.";
    
                    if (customError != null) {
                        mainMessage = customError;
                    } else if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                        mainMessage = errorMessage;
                    } else if (ex != null && ex.getMessage() != null) {
                        mainMessage = ex.getMessage();
                    }
                %>

                <div class="alert alert-warning" role="alert">
                    <i class="fas fa-info-circle me-2"></i>
                    <%= mainMessage %>
                </div>

                <div class="error-details">
                    <h5><i class="fas fa-bug me-2"></i>Información del Error:</h5>

                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Código de Estado:</strong> 
                                <%= statusCode != null ? statusCode : "N/A" %>
                            </p>
                            <p><strong>URI Solicitada:</strong> 
                                <%= requestUri != null ? requestUri : "N/A" %>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Servlet:</strong> 
                                <%= servletName != null ? servletName : "N/A" %>
                            </p>
                            <p><strong>Fecha/Hora:</strong> 
                                <%= new java.util.Date() %>
                            </p>
                        </div>
                    </div>
                            
                    <% if (ex != null) { %>
                    <button class="btn btn-sm btn-outline-secondary mt-2" onclick="toggleTechnicalDetails()">
                        <i class="fas fa-code me-1"></i>Mostrar detalles técnicos
                    </button>

                    <div class="technical-details" id="technicalDetails">
                        <pre><strong>Excepción:</strong> <%= ex.getClass().getName() %>
<strong>Mensaje:</strong> <%= ex.getMessage() != null ? ex.getMessage() : "Sin mensaje" %>

<strong>Stack Trace:</strong>
                            <% 
                                java.io.StringWriter sw = new java.io.StringWriter();
                                java.io.PrintWriter pw = new java.io.PrintWriter(sw);
                                ex.printStackTrace(pw);
                                out.print(sw.toString());
                            %></pre>
                    </div>
                    <% } %>
                </div>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/portalempleados" class="btn btn-custom">
                        <i class="fas fa-home me-1"></i>Volver al Inicio
                    </a>
                    <a href="javascript:history.back()" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Volver Atrás
                    </a>
                    <button onclick="location.reload()" class="btn btn-outline-primary">
                        <i class="fas fa-redo me-1"></i>Reintentar
                    </button>
                </div>

                <div class="mt-4 text-center text-muted">
                    <small>
                        <i class="fas fa-shield-alt me-1"></i>
                        Si el problema persiste, contacte al administrador del sistema.
                    </small>
                </div>
            </div>
        </div>

        <script>
            function toggleTechnicalDetails() {
                const details = document.getElementById('technicalDetails');
                const button = event.currentTarget;

                if (details.style.display === 'none' || details.style.display === '') {
                    details.style.display = 'block';
                    button.innerHTML = '<i class="fas fa-code me-1"></i>Ocultar detalles técnicos';
                    details.setAttribute('tabindex', '-1');
                    details.focus();
                } else {
                    details.style.display = 'none';
                    button.innerHTML = '<i class="fas fa-code me-1"></i>Mostrar detalles técnicos';
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                const technicalDetails = document.getElementById('technicalDetails');
                if (technicalDetails) {
                    technicalDetails.style.display = 'none';
                }

                const buttons = document.querySelectorAll('button, .btn-custom');
                buttons.forEach(button => {
                    button.setAttribute('tabindex', '0');
                });
            });
        </script>
    </body>
</html>