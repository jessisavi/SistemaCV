package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import portalempleado.utilidades.BasedeDatos;
import portalempleadosmodelo.Rol;
import sistemacv.dao.RolDAO;

@WebServlet(name = "RolesSv", urlPatterns = {"/rolessv"})
public class RolesSv extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("portalempleados");
            return;
        }

        String action = request.getParameter("action");

        try (Connection connection = BasedeDatos.getConnection()) {
            RolDAO rolDAO = new RolDAO(connection);

            if (action == null) {
                listarRoles(request, response, rolDAO, session);
                
            } else switch (action) {
                case "editar":
                    editarRol(request, response, rolDAO);
                    break;
                case "eliminar":
                    eliminarRol(request, response, rolDAO);
                    break;
                default:
                    listarRoles(request, response, rolDAO, session);
                    break;
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error inesperado: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("portalempleados");
            return;
        }

        String action = request.getParameter("action");

        try (Connection connection = BasedeDatos.getConnection()) {
            RolDAO rolDAO = new RolDAO(connection);

            if ("crear".equals(action)) {
                crearRol(request, response, rolDAO, session);
                
            } else if ("actualizar".equals(action)) {
                actualizarRol(request, response, rolDAO);
                
            } else {
                listarRoles(request, response, rolDAO, session);
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error inesperado: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listarRoles(HttpServletRequest request, HttpServletResponse response, 
                           RolDAO rolDAO, HttpSession session) 
            throws ServletException, IOException, SQLException {
        
        List<Rol> roles = rolDAO.obtenerTodosLosRoles();
        request.setAttribute("roles", roles);
        request.setAttribute("totalRoles", roles.size());
        request.setAttribute("totalUsuarios", calcularTotalUsuarios(roles));
        
        if (session.getAttribute("nombreUsuario") != null) {
            request.setAttribute("nombreUsuario", session.getAttribute("nombreUsuario"));
            request.setAttribute("rolUsuario", session.getAttribute("rolUsuario"));
        }
        
        request.getRequestDispatcher("/roles.jsp").forward(request, response);
    }

    private void editarRol(HttpServletRequest request, HttpServletResponse response, RolDAO rolDAO)
            throws ServletException, IOException, SQLException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Rol rol = rolDAO.obtenerRolPorId(id);
            
            if (rol != null) {
                request.setAttribute("rol", rol);
                request.getRequestDispatcher("/editar-rol.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Rol no encontrado");
                request.getRequestDispatcher("/roles.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de rol inválido");
            request.getRequestDispatcher("/roles.jsp").forward(request, response);
        }
    }

    private void eliminarRol(HttpServletRequest request, HttpServletResponse response, RolDAO rolDAO)
            throws ServletException, IOException, SQLException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean eliminado = rolDAO.eliminarRol(id);
            
            if (eliminado) {
                response.sendRedirect(request.getContextPath() + "/rolessv?success=delete");
            } else {
                response.sendRedirect(request.getContextPath() + "/rolessv?error=Error al eliminar el rol");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/rolessv?error=ID de rol inválido");
        }
    }

    private void crearRol(HttpServletRequest request, HttpServletResponse response, 
                         RolDAO rolDAO, HttpSession session) 
            throws ServletException, IOException, SQLException {
        
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String[] permisosArray = request.getParameterValues("permisos");
        
        if (nombre == null || nombre.trim().isEmpty() || 
            descripcion == null || descripcion.trim().isEmpty()) {
            
            request.setAttribute("error", "Nombre y descripción son obligatorios");
            listarRoles(request, response, rolDAO, session);
            return;
        }
        
        Rol rol = new Rol();
        rol.setNombre(nombre.trim());
        rol.setDescripcion(descripcion.trim());
        rol.setNumeroUsuarios(0);
        
        if (permisosArray != null && permisosArray.length > 0) {
            rol.setPermisos(Arrays.asList(permisosArray));
        }
        
        boolean creado = rolDAO.crearRol(rol);
        
        if (creado) {
            response.sendRedirect(request.getContextPath() + "/rolessv?success=create");
        } else {
            request.setAttribute("error", "Error al crear el rol. El nombre puede ya existir.");
            listarRoles(request, response, rolDAO, session);
        }
    }

    private void actualizarRol(HttpServletRequest request, HttpServletResponse response, RolDAO rolDAO)
            throws ServletException, IOException, SQLException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            String[] permisosArray = request.getParameterValues("permisos");
            
            if (nombre == null || nombre.trim().isEmpty() || 
                descripcion == null || descripcion.trim().isEmpty()) {
                
                request.setAttribute("error", "Nombre y descripción son obligatorios");
                Rol rolExistente = rolDAO.obtenerRolPorId(id);
                request.setAttribute("rol", rolExistente);
                request.getRequestDispatcher("/editar-rol.jsp").forward(request, response);
                return;
            }
            
            Rol rolExistente = rolDAO.obtenerRolPorId(id);
            if (rolExistente == null) {
                request.setAttribute("error", "Rol no encontrado");
                request.getRequestDispatcher("/roles.jsp").forward(request, response);
                return;
            }
            
            Rol rol = new Rol();
            rol.setId(id);
            rol.setNombre(nombre.trim());
            rol.setDescripcion(descripcion.trim());
            rol.setNumeroUsuarios(rolExistente.getNumeroUsuarios());
            
            if (permisosArray != null && permisosArray.length > 0) {
                rol.setPermisos(Arrays.asList(permisosArray));
            }
            
            boolean actualizado = rolDAO.actualizarRol(rol);
            
            if (actualizado) {
                response.sendRedirect(request.getContextPath() + "/rolessv?success=update");
            } else {
                request.setAttribute("error", "Error al actualizar el rol");
                request.setAttribute("rol", rol);
                request.getRequestDispatcher("/editar-rol.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de rol inválido");
            request.getRequestDispatcher("/roles.jsp").forward(request, response);
        }
    }

    private int calcularTotalUsuarios(List<Rol> roles) {
        return roles.stream().mapToInt(Rol::getNumeroUsuarios).sum();
    }
}