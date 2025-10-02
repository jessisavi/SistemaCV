package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import portalempleadosmodelo.Usuario;

@WebServlet(name = "DashboardSv", urlPatterns = {"/dashboard"})
public class DashboardSv extends HttpServlet { 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("portalempleados");
            return;
        }
        
        try {
            configurarAtributosUsuario(request, session);
            configurarMensajes(request);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error al cargar el dashboard");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void configurarAtributosUsuario(HttpServletRequest request, HttpSession session) {
        Object usuarioObj = session.getAttribute("usuario");
        
        if (usuarioObj instanceof Usuario) {
            Usuario usuario = (Usuario) usuarioObj;
            request.setAttribute("nombreUsuario", usuario.getUsuario());
            
            String rol = usuario.getRol() != null ? usuario.getRol() : "Asesor Comercial";
            request.setAttribute("rolUsuario", rol);
            
            session.setAttribute("nombreUsuario", usuario.getUsuario());
            session.setAttribute("rolUsuario", rol);
            
        } else {
            request.setAttribute("nombreUsuario", "Usuario");
            request.setAttribute("rolUsuario", "Asesor Comercial");
            
            session.setAttribute("nombreUsuario", "Usuario");
            session.setAttribute("rolUsuario", "Asesor Comercial");
        }
    }
    
    private void configurarMensajes(HttpServletRequest request) {
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        if (success != null && !success.trim().isEmpty()) {
            request.setAttribute("success", success);
        }
        if (error != null && !error.trim().isEmpty()) {
            request.setAttribute("error", error);
        }
    }
}