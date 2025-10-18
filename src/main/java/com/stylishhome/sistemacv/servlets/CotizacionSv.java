package com.stylishhome.sistemacv.servlets;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import portalempleadosmodelo.Cliente;
import portalempleadosmodelo.Cotizacion;
import portalempleadosmodelo.CotizacionDetalle;
import portalempleadosmodelo.Producto;
import sistemacv.dao.ClienteDAO;
import sistemacv.dao.CotizacionDAO;
import sistemacv.dao.ProductoDAO;

@WebServlet(name = "CotizacionSv", urlPatterns = {"/cotizaciones", "/cotizaciones/crear", "/cotizaciones/editar", "/cotizaciones/guardar", "/cotizaciones/estado"})
public class CotizacionSv extends HttpServlet {

    private CotizacionDAO cotizacionDAO;
    private ClienteDAO clienteDAO;
    private ProductoDAO productoDAO;

    @Override
    public void init() throws ServletException {
        cotizacionDAO = new CotizacionDAO();
        clienteDAO = new ClienteDAO();
        productoDAO = new ProductoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados");
            return;
        }

        try {
            switch (action) {
                case "/cotizaciones":
                    String subAction = request.getParameter("action");
                    if ("ver".equals(subAction)) {
                        mostrarDetalleCotizacion(request, response);
                    } else if ("nuevo".equals(subAction)) {
                        mostrarFormularioCrear(request, response);
                    } else if ("editar".equals(subAction)) {
                        mostrarFormularioEditar(request, response); 
                    } else {
                        listarCotizaciones(request, response);
                    }
                    break;
                case "/cotizaciones/crear":
                    mostrarFormularioCrear(request, response);
                    break;
                case "/cotizaciones/editar":
                    mostrarFormularioEditar(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/cotizaciones");
                    break;
            }
        } catch (Exception e) {
            System.err.println("ERROR en doGet: " + e.getMessage());
            e.printStackTrace();

            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Error+en+el+sistema");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados");
            return;
        }

        try {
            switch (action) {
                case "/cotizaciones/guardar":
                    guardarCotizacion(request, response);
                    break;
                case "/cotizaciones/estado":
                    cambiarEstado(request, response);
                    break;
                default:
                    listarCotizaciones(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cotizaciones");
        }
    }

    private void mostrarDetalleCotizacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cotizaciones");
                return;
            }

            int id = Integer.parseInt(idParam);
            Cotizacion cotizacion = cotizacionDAO.obtenerCotizacionPorId(id);

            if (cotizacion == null) {
                request.setAttribute("error", "Cotización no encontrada");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("cotizacion", cotizacion);
            request.getRequestDispatcher("/cotizacionDetalle.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el detalle de la cotización: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listarCotizaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getAttribute("cotizaciones_processed") != null) {
            System.err.println("DEBUG: Evitando recursión en listarCotizaciones");
            return;
        }
        request.setAttribute("cotizaciones_processed", true);

        Connection conn = null;

        try {
            System.out.println("DEBUG: Iniciando listarCotizaciones - versión corregida");

            String filtroEstado = request.getParameter("filtroEstado");
            String busqueda = request.getParameter("busqueda");

            List<Cotizacion> cotizaciones = cotizacionDAO.obtenerTodasLasCotizaciones();
            System.out.println("DEBUG: Cotizaciones obtenidas: " + cotizaciones.size());

            if (filtroEstado != null && !filtroEstado.isEmpty() && !filtroEstado.equals("Todas")) {
                cotizaciones.removeIf(c -> !c.getEstado().equalsIgnoreCase(filtroEstado));
            }

            if (busqueda != null && !busqueda.trim().isEmpty()) {
                String busquedaLower = busqueda.toLowerCase();
                cotizaciones.removeIf(c
                        -> !c.getNumeroCotizacion().toLowerCase().contains(busquedaLower)
                        && !c.getCliente().getNombre().toLowerCase().contains(busquedaLower)
                );
            }

            int cotizacionesHoy = 0;
            int pendientes = 0;
            int aprobadas = 0;
            BigDecimal valorTotal = BigDecimal.ZERO;

            try {
                cotizacionesHoy = cotizacionDAO.obtenerCotizacionesHoy();
                pendientes = cotizacionDAO.obtenerCotizacionesPendientes();
                aprobadas = cotizacionDAO.obtenerCotizacionesAprobadas();
                valorTotal = cotizacionDAO.obtenerValorTotal();
            } catch (Exception e) {
                System.err.println("ERROR obteniendo estadísticas: " + e.getMessage());
            }

            request.setAttribute("cotizaciones", cotizaciones);
            request.setAttribute("cotizacionesHoy", cotizacionesHoy);
            request.setAttribute("pendientes", pendientes);
            request.setAttribute("aprobadas", aprobadas);
            request.setAttribute("valorTotal", valorTotal);
            request.setAttribute("filtroEstado", filtroEstado);
            request.setAttribute("busqueda", busqueda);

            String jspPath = "/cotizacionLista.jsp";

            if (getServletContext().getResource(jspPath) == null) {
                System.err.println("ERROR: JSP no encontrado: " + jspPath);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Página no encontrada: " + jspPath);
                return;
            }

            System.out.println("DEBUG: Forward seguro a " + jspPath);

            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            if (dispatcher != null) {
                dispatcher.forward(request, response);
            } else {
                System.err.println("ERROR: Dispatcher es null para: " + jspPath);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno del servidor");
            }

        } catch (Exception e) {
            System.err.println("ERROR en listarCotizaciones: " + e.getMessage());
            e.printStackTrace();

            try {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Error+al+cargar+cotizaciones");
            } catch (IOException ioException) {
                System.err.println("ERROR crítico al redirigir: " + ioException.getMessage());
            }
        }
    }

    private void mostrarFormularioCrear(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            ClienteDAO clienteDAO = new ClienteDAO();
            ProductoDAO productoDAO = new ProductoDAO();

            List<Cliente> clientes = clienteDAO.obtenerTodosLosClientes();
            List<Producto> productos = productoDAO.obtenerTodosLosProductos();

            request.setAttribute("clientes", clientes);
            request.setAttribute("productos", productos);

            LocalDate fechaActual = LocalDate.now();
            LocalDate fechaValido = fechaActual.plusDays(30);

            request.setAttribute("fechaActual", fechaActual);
            request.setAttribute("fechaValido", fechaValido);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/cotizacionFormulario.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el formulario: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cotizaciones");
        }
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cotizaciones");
                return;
            }

            int id = Integer.parseInt(idParam);
            Cotizacion cotizacion = cotizacionDAO.obtenerCotizacionPorId(id);

            if (cotizacion == null) {
                request.setAttribute("error", "Cotización no encontrada");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            List<Cliente> clientes = clienteDAO.obtenerTodosLosClientes();
            List<Producto> productos = productoDAO.obtenerTodosLosProductos();

            request.setAttribute("cotizacion", cotizacion);
            request.setAttribute("clientes", clientes);
            request.setAttribute("productos", productos);

            request.getRequestDispatcher("/cotizacionFormulario.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar formulario de edición: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void guardarCotizacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            Cotizacion cotizacion = new Cotizacion();

            String clienteIdStr = request.getParameter("clienteId");
            if (clienteIdStr == null || clienteIdStr.isEmpty()) {
                throw new Exception("El ID del cliente es requerido");
            }

            cotizacion.setClienteId(Integer.parseInt(clienteIdStr));
            cotizacion.setFecha(LocalDate.parse(request.getParameter("fecha")));
            cotizacion.setValidoHasta(LocalDate.parse(request.getParameter("validoHasta")));
            cotizacion.setProyecto(request.getParameter("proyecto"));
            cotizacion.setNotas(request.getParameter("notas"));
            cotizacion.setTerminos(request.getParameter("terminos"));
            cotizacion.setEstado("PENDIENTE");

            Object usuarioIdObj = session.getAttribute("usuarioId");
            if (usuarioIdObj != null) {
                cotizacion.setUsuarioId((Integer) usuarioIdObj);
            } else {
                cotizacion.setUsuarioId(1);
            }

            List<CotizacionDetalle> detalles = new ArrayList<>();
            String[] productoIds = request.getParameterValues("productoId");
            String[] cantidades = request.getParameterValues("cantidad");
            String[] precios = request.getParameterValues("precioUnitario");
            String[] descuentos = request.getParameterValues("descuento");

            BigDecimal subtotal = BigDecimal.ZERO;

            if (productoIds != null) {
                for (int i = 0; i < productoIds.length; i++) {
                    if (productoIds[i] != null && !productoIds[i].isEmpty()) {
                        CotizacionDetalle detalle = new CotizacionDetalle();
                        detalle.setProductoId(Integer.parseInt(productoIds[i]));
                        detalle.setCantidad(Integer.parseInt(cantidades[i]));

                        String precioLimpio = precios[i].replace("$", "").replace(".", "").replace(",", ".");
                        detalle.setPrecioUnitario(new BigDecimal(precioLimpio));

                        String descuentoStr = descuentos[i];
                        if (descuentoStr != null && !descuentoStr.isEmpty()) {
                            if (descuentoStr.contains("%")) {
                                String porcentajeLimpio = descuentoStr.replace("%", "").trim();
                                detalle.setDescuentoPorcentaje(new BigDecimal(porcentajeLimpio));
                            } else {
                                String montoLimpio = descuentoStr.replace("$", "").replace(".", "").replace(",", ".");
                                detalle.setDescuentoMonto(new BigDecimal(montoLimpio));
                            }
                        }

                        detalle.calcularTotal();
                        detalles.add(detalle);
                        subtotal = subtotal.add(detalle.getTotal());
                    }
                }
            }

            cotizacion.setDetalles(detalles);
            cotizacion.setSubtotal(subtotal);

            BigDecimal iva = subtotal.multiply(new BigDecimal("0.19"));
            BigDecimal descuentoTotal = BigDecimal.ZERO;

            for (CotizacionDetalle detalle : detalles) {
                if (detalle.getDescuentoMonto() != null) {
                    descuentoTotal = descuentoTotal.add(detalle.getDescuentoMonto());
                }
            }

            BigDecimal total = subtotal.add(iva).subtract(descuentoTotal);

            cotizacion.setIva(iva);
            cotizacion.setDescuento(descuentoTotal);
            cotizacion.setTotal(total);

            boolean exito = cotizacionDAO.crearCotizacion(cotizacion);

            if (exito) {
                session.setAttribute("mensaje", "Cotización creada exitosamente: " + cotizacion.getNumeroCotizacion());
                response.sendRedirect(request.getContextPath() + "/cotizaciones");
            } else {
                throw new Exception("No se pudo guardar la cotización en la base de datos");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al guardar cotización: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cotizaciones/crear");
        }
    }

    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            String idParam = request.getParameter("id");
            String nuevoEstado = request.getParameter("estado");

            if (idParam == null || nuevoEstado == null) {
                session.setAttribute("error", "Parámetros incompletos");
                response.sendRedirect(request.getContextPath() + "/cotizaciones");
                return;
            }

            int id = Integer.parseInt(idParam);
            boolean exito = cotizacionDAO.actualizarEstado(id, nuevoEstado);

            if (exito) {
                session.setAttribute("mensaje", "Estado de cotización actualizado exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar el estado de la cotización");
            }

            response.sendRedirect(request.getContextPath() + "/cotizaciones");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al cambiar estado: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cotizaciones");
        }
    }
}
