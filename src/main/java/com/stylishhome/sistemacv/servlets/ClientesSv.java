package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import portalempleado.utilidades.BasedeDatos;

@WebServlet(name = "ClientesSv", urlPatterns = {"/clientes"})
public class ClientesSv extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("portalempleados");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("lista")) {
                mostrarListaClientes(request, response);
            } else if (action.equals("detalle")) {
                mostrarDetalleCliente(request, response);
            } else if (action.equals("nuevo")) {
                mostrarFormularioCliente(request, response, null);
            } else if (action.equals("editar")) {
                mostrarFormularioCliente(request, response, request.getParameter("id"));
            } else {
                mostrarListaClientes(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al procesar la solicitud");
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

        try {
            if ("guardar".equals(action)) {
                guardarCliente(request, response);
            } else if ("eliminar".equals(action)) {
                eliminarCliente(request, response);
            } else {
                response.sendRedirect("clientes?error=Acción no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al procesar la solicitud");
        }
    }

    private void mostrarListaClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = BasedeDatos.getConnection();
            String sql = "SELECT idcliente, nombre, apellido, correo_electronico, celular, tipo_cliente, fecha_registro, "
                    + "tipo_documento, numero_documento "
                    + "FROM clientes ORDER BY fecha_registro DESC";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Map<String, String>> clientes = new ArrayList<>();
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            while (rs.next()) {
                Map<String, String> cliente = new HashMap<>();
                cliente.put("id", String.valueOf(rs.getInt("idcliente")));
                cliente.put("codigo", "CL-" + String.format("%05d", rs.getInt("idcliente")));
                cliente.put("nombre", rs.getString("nombre") + " " + rs.getString("apellido"));
                cliente.put("email", rs.getString("correo_electronico"));
                cliente.put("telefono", rs.getString("celular"));
                cliente.put("tipo", rs.getString("tipo_cliente"));

                Date fechaRegistro = rs.getDate("fecha_registro");
                cliente.put("fecha_registro", fechaRegistro != null ? dateFormat.format(fechaRegistro) : "N/A");

                clientes.add(cliente);
            }

            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("/clienteLista.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de clientes: " + e.getMessage());
            request.getRequestDispatcher("/clienteLista.jsp").forward(request, response);
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt, rs);
        }
    }

    private void mostrarDetalleCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idCliente = request.getParameter("id");

        if (idCliente == null || idCliente.isEmpty()) {
            response.sendRedirect("clientes?error=ID de cliente no válido");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = BasedeDatos.getConnection();

            String sqlCliente = "SELECT * FROM clientes WHERE idcliente = ?";
            pstmt = conn.prepareStatement(sqlCliente);
            pstmt.setInt(1, Integer.parseInt(idCliente));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Map<String, String> cliente = new HashMap<>();
                cliente.put("id", String.valueOf(rs.getInt("idcliente")));
                cliente.put("codigo", "CL-" + String.format("%05d", rs.getInt("idcliente")));
                cliente.put("nombre", rs.getString("nombre"));
                cliente.put("apellido", rs.getString("apellido"));
                cliente.put("email", rs.getString("correo_electronico"));
                cliente.put("telefono", rs.getString("celular"));
                cliente.put("tipo_documento", rs.getString("tipo_documento"));
                cliente.put("numero_documento", rs.getString("numero_documento"));
                cliente.put("direccion", rs.getString("direccion"));
                cliente.put("ciudad", rs.getString("ciudad"));
                cliente.put("tipo_cliente", rs.getString("tipo_cliente"));

                Date fechaRegistro = rs.getDate("fecha_registro");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                cliente.put("fecha_registro", fechaRegistro != null ? dateFormat.format(fechaRegistro) : "N/A");

                cliente.put("estado", "Activo");

                request.setAttribute("cliente", cliente);

                List<Map<String, String>> compras = new ArrayList<>();
                request.setAttribute("compras", compras);

                request.getRequestDispatcher("/clienteDetalle.jsp").forward(request, response);
            } else {
                response.sendRedirect("clientes?error=Cliente no encontrado");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al cargar el cliente: " + e.getMessage());
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt, rs);
        }
    }

    private void mostrarFormularioCliente(HttpServletRequest request, HttpServletResponse response, String idCliente)
            throws ServletException, IOException {

        Map<String, String> cliente = null;

        if (idCliente != null && !idCliente.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                conn = BasedeDatos.getConnection();
                String sql = "SELECT * FROM clientes WHERE idcliente = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(idCliente));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    cliente = new HashMap<>();
                    cliente.put("id", String.valueOf(rs.getInt("idcliente")));
                    cliente.put("nombre", rs.getString("nombre"));
                    cliente.put("apellido", rs.getString("apellido"));
                    cliente.put("correo_electronico", rs.getString("correo_electronico"));
                    cliente.put("celular", rs.getString("celular"));
                    cliente.put("tipo_documento", rs.getString("tipo_documento"));
                    cliente.put("numero_documento", rs.getString("numero_documento"));
                    cliente.put("direccion", rs.getString("direccion"));
                    cliente.put("ciudad", rs.getString("ciudad"));
                    cliente.put("tipo_cliente", rs.getString("tipo_cliente"));
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error al cargar el cliente: " + e.getMessage());
            } finally {
                BasedeDatos.cerrarRecursos(conn, pstmt, rs);
            }
        }

        request.setAttribute("cliente", cliente);
        request.getRequestDispatcher("/clienteFormulario.jsp").forward(request, response);
    }

    private void guardarCliente(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String id = request.getParameter("id");
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String tipoDocumento = request.getParameter("tipo_documento");
            String numeroDocumento = request.getParameter("numero_documento");
            String direccion = request.getParameter("direccion");
            String ciudad = request.getParameter("ciudad");
            String celular = request.getParameter("celular");
            String correoElectronico = request.getParameter("correo_electronico");
            String tipoCliente = request.getParameter("tipo_cliente");

            if (nombre == null || nombre.trim().isEmpty()
                    || apellido == null || apellido.trim().isEmpty()) {
                response.sendRedirect("clientes?action=nuevo&error=El nombre y apellido son requeridos");
                return;
            }

            conn = BasedeDatos.getConnection();

            if (id == null || id.isEmpty()) {

                String sql = "INSERT INTO clientes (nombre, apellido, tipo_documento, numero_documento, "
                        + "direccion, ciudad, celular, correo_electronico, tipo_cliente, fecha_registro) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURDATE())";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nombre);
                pstmt.setString(2, apellido);
                pstmt.setString(3, tipoDocumento);
                pstmt.setString(4, numeroDocumento);
                pstmt.setString(5, direccion);
                pstmt.setString(6, ciudad);
                pstmt.setString(7, celular);
                pstmt.setString(8, correoElectronico);
                pstmt.setString(9, tipoCliente != null ? tipoCliente : "Regular");

            } else {
                String sql = "UPDATE clientes SET nombre = ?, apellido = ?, tipo_documento = ?, "
                        + "numero_documento = ?, direccion = ?, ciudad = ?, celular = ?, "
                        + "correo_electronico = ?, tipo_cliente = ? WHERE idcliente = ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nombre);
                pstmt.setString(2, apellido);
                pstmt.setString(3, tipoDocumento);
                pstmt.setString(4, numeroDocumento);
                pstmt.setString(5, direccion);
                pstmt.setString(6, ciudad);
                pstmt.setString(7, celular);
                pstmt.setString(8, correoElectronico);
                pstmt.setString(9, tipoCliente != null ? tipoCliente : "Regular");
                pstmt.setInt(10, Integer.parseInt(id));
            }

            int filasAfectadas = pstmt.executeUpdate();

            if (filasAfectadas > 0) {
                response.sendRedirect("clientes?success=Cliente " + (id != null ? "actualizado" : "creado") + " correctamente");
            } else {
                response.sendRedirect("clientes?error=No se pudo guardar el cliente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            String errorMsg = "Error al guardar el cliente: " + e.getMessage();
            if (e.getMessage().contains("Duplicate entry")) {
                errorMsg = "Error: El número de documento o correo electrónico ya existe";
            }
            response.sendRedirect("clientes?action=" + (request.getParameter("id") != null ? "editar&id=" + request.getParameter("id") : "nuevo")
                    + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt);
        }
    }

    private void eliminarCliente(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            response.sendRedirect("clientes?error=ID de cliente no válido");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = BasedeDatos.getConnection();
            String sql = "DELETE FROM clientes WHERE idcliente = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(id));

            int filasAfectadas = pstmt.executeUpdate();

            if (filasAfectadas > 0) {
                response.sendRedirect("clientes?success=Cliente eliminado correctamente");
            } else {
                response.sendRedirect("clientes?error=No se pudo eliminar el cliente");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al eliminar el cliente: " + e.getMessage());
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt);
        }
    }
}
