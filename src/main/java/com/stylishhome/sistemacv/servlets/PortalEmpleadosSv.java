package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import portalempleado.utilidades.BasedeDatos;
import portalempleadosmodelo.Usuario;

@WebServlet(name = "PortalEmpleadosSv", urlPatterns = {"/portalempleados"})
public class PortalEmpleadosSv extends HttpServlet {

    private static final Logger logger = Logger.getLogger(PortalEmpleadosSv.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession existingSession = request.getSession(false);

        if (existingSession != null && existingSession.getAttribute("usuario") != null) {
            logger.info("Usuario ya autenticado, redirigiendo al dashboard");
            response.sendRedirect("dashboard");
            return;
        }

        String error = request.getParameter("error");

        if (error != null && !error.trim().isEmpty()) {
            request.setAttribute("error", error);
        }

        if (existingSession != null) {
            existingSession.invalidate();
            logger.info("Sesión existente invalidada");
        }

        request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String username = obtenerParametroSeguro(request, "usuario");
            String password = obtenerParametroSeguro(request, "contraseña");
            String recordar = request.getParameter("recordar");

            if (username == null || username.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {

                logger.warning("Intento de login con campos vacíos");
                request.setAttribute("error", "Usuario y contraseña son requeridos");
                request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
                return;
            }

            username = username.trim();
            password = password.trim();

            if (username.length() < 3 || password.length() < 4) {
                logger.warning("Intento de login con credenciales muy cortas");
                request.setAttribute("error", "Credenciales inválidas");
                request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
                return;
            }

            connection = BasedeDatos.getConnection();
            Usuario usuarioAutenticado = autenticarUsuarioBD(connection, username, password);

            if (usuarioAutenticado != null) {
                HttpSession session = request.getSession();

                if ("on".equals(recordar)) {
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60); 
                    logger.info("Sesión persistente configurada para usuario: " + username);
                } else {
                    session.setMaxInactiveInterval(30 * 60); 
                    logger.info("Sesión temporal configurada para usuario: " + username);
                }

                session.setAttribute("usuario", usuarioAutenticado);
                session.setAttribute("nombreUsuario", usuarioAutenticado.getUsuario()); 
                session.setAttribute("rolUsuario", usuarioAutenticado.getRol());
                session.setAttribute("ultimoAcceso", new java.util.Date());

                logger.info("Usuario autenticado exitosamente: " + username
                        + " - Rol: " + usuarioAutenticado.getRol()
                        + " - ID: " + usuarioAutenticado.getIdempleado());

                response.sendRedirect("dashboard");

            } else {
                logger.warning("Intento de login fallido para usuario: " + username);
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error de base de datos durante la autenticación", e);
            request.setAttribute("error", "Error de conexión con la base de datos. Por favor, intente nuevamente.");
            request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error durante el proceso de autenticación", e);
            request.setAttribute("error", "Error interno del sistema. Por favor, intente nuevamente.");
            request.getRequestDispatcher("/portalempleados.jsp").forward(request, response);
        } finally {
            cerrarRecursos(rs, stmt, connection);
        }
    }

    private Usuario autenticarUsuarioBD(Connection connection, String username, String password) throws SQLException {
        String sql = "SELECT idempleado, usuario, contraseña, rol FROM portalempleados WHERE usuario = ? AND contraseña = ?";

        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); 

            rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdempleado(rs.getInt("idempleado"));
                usuario.setUsuario(rs.getString("usuario"));
                usuario.setContraseña(rs.getString("contraseña"));
                usuario.setRol(rs.getString("rol"));
                return usuario;
            }

            return null;

        } finally {
            cerrarRecursos(rs, stmt, null); 
        }
    }

    private String obtenerParametroSeguro(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value != null ? value.trim() : null;
    }

    private void cerrarRecursos(ResultSet rs, PreparedStatement stmt, Connection connection) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            logger.warning("Error al cerrar ResultSet: " + e.getMessage());
        }

        try {
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException e) {
            logger.warning("Error al cerrar PreparedStatement: " + e.getMessage());
        }

        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            logger.warning("Error al cerrar Connection: " + e.getMessage());
        }
    }

    @Override
    public void init() throws ServletException {
        logger.info("Servlet PortalEmpleadosSv inicializado");
    }

    @Override
    public void destroy() {
        logger.info("Servlet PortalEmpleadosSv siendo destruido");
    }
}