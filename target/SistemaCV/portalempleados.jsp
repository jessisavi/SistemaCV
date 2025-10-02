<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session != null && session.getAttribute("usuario") != null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Iniciar Sesión | Portal de Empleados</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StylePE.css">
    </head>
    <body>
        <div class="login-wrapper">
            <div class="login-container">
                <div class="login-header">
                    <div>
                        <img src="${pageContext.request.contextPath}/images/StylishHome.jpg" 
                             alt="Logo Stylish Home">
                    </div>
                    <h4>Bienvenido al Portal de Empleados</h4>
                </div>

                <div class="login-body">
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

                    <form action="${pageContext.request.contextPath}/portalempleados" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="usuario" class="form-label">
                                <i class="fas fa-user"></i>Usuario
                            </label>
                            <input type="text" class="form-control" id="usuario" name="usuario" 
                                   placeholder="Ingrese su usuario" required autocomplete="username"
                                   autofocus>
                        </div>

                        <div class="form-group">
                            <label for="contraseña" class="form-label">
                                <i class="fas fa-lock"></i>Contraseña
                            </label>
                            <div style="position: relative;">
                                <input type="password" class="form-control" id="contrasena" name="contraseña" 
                                       placeholder="Ingrese su contraseña" required autocomplete="current-password">
                                <button type="button" class="password-toggle" id="togglePassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="recordar" name="recordar">
                            <label class="form-check-label" for="recordar">
                                Recordar mi sesión
                            </label>
                        </div>

                        <button type="submit" class="btn btn-login" id="submitBtn">
                            <i class="fas fa-sign-in-alt"></i>Iniciar Sesión
                        </button>
                    </form>

                    <div class="login-footer">
                        <a href="#" class="forgot-link">
                            <i class="fas fa-key"></i>¿Olvidó su contraseña?
                        </a>
                    </div>

                    <div class="system-info">
                        <small>
                            <i class="fas fa-shield-alt"></i>
                            Sistema seguro - Stylish Home
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var loginForm = document.getElementById('loginForm');
                var togglePassword = document.getElementById('togglePassword');
                var passwordInput = document.getElementById('contrasena'); // ID corregido
                var submitBtn = document.getElementById('submitBtn');
                var usuarioInput = document.getElementById('usuario');

                // Toggle password visibility
                if (togglePassword && passwordInput) {
                    togglePassword.addEventListener('click', function () {
                        var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                        passwordInput.setAttribute('type', type);
                        this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
                    });
                }

                // Form validation and submission
                if (loginForm) {
                    loginForm.addEventListener('submit', function (e) {
                        var usuario = usuarioInput ? usuarioInput.value.trim() : '';
                        var contrasena = passwordInput ? passwordInput.value : '';

                        // Clear previous errors
                        clearError();

                        // Validation
                        if (usuario === '' || contrasena === '') {
                            e.preventDefault();
                            showError('Por favor, complete todos los campos requeridos.');
                            return false;
                        }

                        if (usuario.length < 3) {
                            e.preventDefault();
                            showError('El usuario debe tener al menos 3 caracteres.');
                            usuarioInput.classList.add('invalid');
                            return false;
                        }

                        if (contrasena.length < 4) {
                            e.preventDefault();
                            showError('La contraseña debe tener al menos 4 caracteres.');
                            passwordInput.classList.add('invalid');
                            return false;
                        }

                        // Show loading state
                        if (submitBtn) {
                            submitBtn.classList.add('loading');
                            submitBtn.innerHTML = '<i class="fas fa-spinner"></i> Iniciando sesión...';
                            submitBtn.disabled = true;
                        }

                        // Re-enable after 5 seconds (fallback)
                        setTimeout(function () {
                            if (submitBtn) {
                                submitBtn.classList.remove('loading');
                                submitBtn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Iniciar Sesión';
                                submitBtn.disabled = false;
                            }
                        }, 5000);
                    });
                }

                // Clear error on input
                if (usuarioInput) {
                    usuarioInput.addEventListener('input', function () {
                        clearError();
                        this.classList.remove('invalid');
                        if (this.value.length >= 3) {
                            this.classList.add('valid');
                        }
                    });
                }

                if (passwordInput) {
                    passwordInput.addEventListener('input', function () {
                        clearError();
                        this.classList.remove('invalid');
                        if (this.value.length >= 4) {
                            this.classList.add('valid');
                        }
                    });
                }

                function showError(message) {
                    var existingAlert = document.querySelector('.alert-danger');
                    if (existingAlert) {
                        existingAlert.remove();
                    }

                    var alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-danger alert-dismissible fade show';
                    alertDiv.setAttribute('role', 'alert');

                    var alertContent = '<i class="fas fa-exclamation-triangle me-2"></i>' + message;
                    alertContent += '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

                    alertDiv.innerHTML = alertContent;

                    if (loginForm && loginForm.parentNode) {
                        loginForm.parentNode.insertBefore(alertDiv, loginForm);
                    }
                }

                function clearError() {
                    var alert = document.querySelector('.alert-danger');
                    if (alert) {
                        alert.style.opacity = '0';
                        setTimeout(function () {
                            if (alert.parentNode) {
                                alert.parentNode.removeChild(alert);
                            }
                        }, 300);
                    }
                }

                // Entrance animations
                var formElements = document.querySelectorAll('.form-group, .form-check, .btn-login');
                for (var i = 0; i < formElements.length; i++) {
                    (function (index) {
                        var element = formElements[index];
                        element.style.opacity = '0';
                        element.style.transform = 'translateY(20px)';
                        setTimeout(function () {
                            element.style.transition = 'all 0.5s ease';
                            element.style.opacity = '1';
                            element.style.transform = 'translateY(0)';
                        }, index * 100);
                    })(i);
                }
            });
        </script>
    </body>
</html>