package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
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
import portalempleadosmodelo.Cliente;
import sistemacv.dao.ClienteDAO;

@WebServlet(name = "ClientesSv", urlPatterns = {"/clientes"})
public class ClientesSv extends HttpServlet {

    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        clienteDAO = new ClienteDAO();
    }

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

        try {
            List<Cliente> listaClientes = clienteDAO.obtenerTodosLosClientes();
            List<Map<String, String>> clientes = new ArrayList<>();
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            for (Cliente cliente : listaClientes) {
                Map<String, String> clienteMap = new HashMap<>();
                clienteMap.put("id", String.valueOf(cliente.getIdcliente()));
                clienteMap.put("codigo", "CL-" + String.format("%05d", cliente.getIdcliente()));
                clienteMap.put("nombre", cliente.getNombre() + " " + (cliente.getApellido() != null ? cliente.getApellido() : ""));
                clienteMap.put("email", cliente.getCorreoElectronico());
                clienteMap.put("telefono", cliente.getCelular());
                clienteMap.put("tipo", cliente.getTipoCliente());

                Date fechaRegistro = cliente.getFechaRegistro() != null
                        ? java.sql.Date.valueOf(cliente.getFechaRegistro()) : null;
                clienteMap.put("fecha_registro", fechaRegistro != null ? dateFormat.format(fechaRegistro) : "N/A");

                clientes.add(clienteMap);
            }

            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("/clienteLista.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de clientes: " + e.getMessage());
            request.getRequestDispatcher("/clienteLista.jsp").forward(request, response);
        }
    }

    private void mostrarDetalleCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idCliente = request.getParameter("id");

        if (idCliente == null || idCliente.isEmpty()) {
            response.sendRedirect("clientes?error=ID de cliente no válido");
            return;
        }

        try {
            Cliente cliente = clienteDAO.obtenerClientePorId(Integer.parseInt(idCliente));

            if (cliente != null) {
                Map<String, String> clienteMap = new HashMap<>();
                clienteMap.put("id", String.valueOf(cliente.getIdcliente()));
                clienteMap.put("codigo", "CL-" + String.format("%05d", cliente.getIdcliente()));
                clienteMap.put("nombre", cliente.getNombre());
                clienteMap.put("apellido", cliente.getApellido());
                clienteMap.put("email", cliente.getCorreoElectronico());
                clienteMap.put("telefono", cliente.getCelular());
                clienteMap.put("tipo_documento", cliente.getTipoDocumento());
                clienteMap.put("numero_documento", cliente.getNumeroDocumento());
                clienteMap.put("direccion", cliente.getDireccion());
                clienteMap.put("ciudad", cliente.getCiudad());
                clienteMap.put("tipo_cliente", cliente.getTipoCliente());

                Date fechaRegistro = cliente.getFechaRegistro() != null
                        ? java.sql.Date.valueOf(cliente.getFechaRegistro()) : null;
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                clienteMap.put("fecha_registro", fechaRegistro != null ? dateFormat.format(fechaRegistro) : "N/A");

                clienteMap.put("estado", "Activo");

                request.setAttribute("cliente", clienteMap);

                List<Map<String, String>> compras = new ArrayList<>();
                request.setAttribute("compras", compras);

                request.getRequestDispatcher("/clienteDetalle.jsp").forward(request, response);
            } else {
                response.sendRedirect("clientes?error=Cliente no encontrado");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al cargar el cliente: " + e.getMessage());
        }
    }

    private void mostrarFormularioCliente(HttpServletRequest request, HttpServletResponse response, String idCliente)
            throws ServletException, IOException {

        Map<String, String> cliente = null;

        if (idCliente != null && !idCliente.isEmpty()) {
            try {
                Cliente clienteObj = clienteDAO.obtenerClientePorId(Integer.parseInt(idCliente));

                if (clienteObj != null) {
                    cliente = new HashMap<>();
                    cliente.put("id", String.valueOf(clienteObj.getIdcliente()));
                    cliente.put("nombre", clienteObj.getNombre());
                    cliente.put("apellido", clienteObj.getApellido());
                    cliente.put("correo_electronico", clienteObj.getCorreoElectronico());
                    cliente.put("celular", clienteObj.getCelular());
                    cliente.put("tipo_documento", clienteObj.getTipoDocumento());
                    cliente.put("numero_documento", clienteObj.getNumeroDocumento());
                    cliente.put("direccion", clienteObj.getDireccion());
                    cliente.put("ciudad", clienteObj.getCiudad());
                    cliente.put("tipo_cliente", clienteObj.getTipoCliente());
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error al cargar el cliente: " + e.getMessage());
            }
        }

        request.setAttribute("cliente", cliente);
        request.getRequestDispatcher("/clienteFormulario.jsp").forward(request, response);
    }

    private void guardarCliente(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

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

            if (nombre == null || nombre.trim().isEmpty() || apellido == null || apellido.trim().isEmpty()) {
                response.sendRedirect("clientes?action=nuevo&error=El nombre y apellido son requeridos");
                return;
            }

            Cliente cliente = new Cliente();
            cliente.setNombre(nombre);
            cliente.setApellido(apellido);
            cliente.setTipoDocumento(tipoDocumento);
            cliente.setNumeroDocumento(numeroDocumento);
            cliente.setDireccion(direccion);
            cliente.setCiudad(ciudad);
            cliente.setCelular(celular);
            cliente.setCorreoElectronico(correoElectronico);
            cliente.setTipoCliente(tipoCliente != null ? tipoCliente : "Regular");
            cliente.setFechaRegistro(java.time.LocalDate.now());

            boolean exito;
            if (id == null || id.isEmpty()) {
                exito = clienteDAO.crearCliente(cliente);
            } else {
                cliente.setIdcliente(Integer.parseInt(id));
                exito = clienteDAO.actualizarCliente(cliente);
            }

            if (exito) {
                response.sendRedirect("clientes?success=Cliente " + (id != null ? "actualizado" : "creado") + " correctamente");
            } else {
                response.sendRedirect("clientes?error=No se pudo guardar el cliente");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "Error al guardar el cliente: " + e.getMessage();
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                errorMsg = "Error: El número de documento o correo electrónico ya existe";
            }
            response.sendRedirect("clientes?action=" + (request.getParameter("id") != null ? "editar&id=" + request.getParameter("id") : "nuevo")
                    + "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }

    private void eliminarCliente(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            response.sendRedirect("clientes?error=ID de cliente no válido");
            return;
        }

        try {
            boolean exito = clienteDAO.eliminarCliente(Integer.parseInt(id));

            if (exito) {
                response.sendRedirect("clientes?success=Cliente eliminado correctamente");
            } else {
                response.sendRedirect("clientes?error=No se pudo eliminar el cliente");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("clientes?error=Error al eliminar el cliente: " + e.getMessage());
        }
    }
}
