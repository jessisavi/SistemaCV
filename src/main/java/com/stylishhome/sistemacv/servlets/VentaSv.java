package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import portalempleadosmodelo.Venta;
import portalempleadosmodelo.VentaDetalle;
import portalempleadosmodelo.Cliente;
import portalempleadosmodelo.Producto;
import sistemacv.dao.VentaDAO;
import sistemacv.dao.ClienteDAO;
import sistemacv.dao.ProductoDAO;

@WebServlet(name = "VentaSv", urlPatterns = {"/ventas", "/ventas/crear", "/ventas/editar", "/ventas/guardar", "/ventas/estado", "/ventas/detalle"})
public class VentaSv extends HttpServlet {

    private VentaDAO ventaDAO;
    private ClienteDAO clienteDAO;
    private ProductoDAO productoDAO;

    @Override
    public void init() throws ServletException {
        ventaDAO = new VentaDAO();
        clienteDAO = new ClienteDAO();
        productoDAO = new ProductoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados.jsp");
            return;
        }

        try {
            switch (action) {
                case "/ventas":
                    listarVentas(request, response);
                    break;
                case "/ventas/crear":
                    mostrarFormularioCrear(request, response);
                    break;
                case "/ventas/editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "/ventas/detalle":
                    mostrarDetalleVenta(request, response);
                    break;
                default:
                    listarVentas(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en servlet de ventas", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados.jsp");
            return;
        }

        try {
            switch (action) {
                case "/ventas/guardar":
                    guardarVenta(request, response);
                    break;
                case "/ventas/estado":
                    cambiarEstado(request, response);
                    break;
                default:
                    listarVentas(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error en servlet de ventas", e);
        }
    }

    private void listarVentas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("DEBUG: VentaSv - listarVentas ejecutándose");

            String filtroEstado = request.getParameter("filtroEstado");
            String busqueda = request.getParameter("busqueda");
            String periodo = request.getParameter("periodo");

            List<Venta> ventas = ventaDAO.obtenerTodasLasVentas();

            if (ventas != null) {
                if (filtroEstado != null && !filtroEstado.isEmpty() && !filtroEstado.equals("Todos")) {
                    ventas.removeIf(v -> v != null && !v.getEstado().equalsIgnoreCase(filtroEstado));
                }

                if (busqueda != null && !busqueda.trim().isEmpty()) {
                    String busquedaLower = busqueda.toLowerCase();
                    ventas.removeIf(v
                            -> v != null
                            && !v.getNumeroFactura().toLowerCase().contains(busquedaLower)
                            && v.getCliente() != null
                            && !v.getCliente().getNombreCompleto().toLowerCase().contains(busquedaLower)
                    );
                }

                if (periodo != null && !periodo.equals("Últimos 7 días")) {
                }
            } else {
                ventas = new ArrayList<>();
            }

            BigDecimal ventasHoy = ventaDAO.obtenerVentasHoy();
            BigDecimal ventasMensuales = ventaDAO.obtenerVentasMensuales();
            BigDecimal ventasAnuales = ventaDAO.obtenerVentasAnuales();
            BigDecimal metaMensual = ventaDAO.obtenerMetaMensual();

            int porcentajeMeta = 0;
            if (metaMensual.compareTo(BigDecimal.ZERO) > 0) {
                porcentajeMeta = ventasMensuales.multiply(BigDecimal.valueOf(100))
                        .divide(metaMensual, 0, BigDecimal.ROUND_HALF_UP)
                        .intValue();
            }

            List<Producto> productosMasVendidos = ventaDAO.obtenerProductosMasVendidos();

            request.setAttribute("ventas", ventas);
            request.setAttribute("ventasHoy", ventasHoy);
            request.setAttribute("ventasMensuales", ventasMensuales);
            request.setAttribute("ventasAnuales", ventasAnuales);
            request.setAttribute("metaMensual", metaMensual);
            request.setAttribute("porcentajeMeta", porcentajeMeta);
            request.setAttribute("productosMasVendidos", productosMasVendidos);
            request.setAttribute("filtroEstado", filtroEstado);
            request.setAttribute("busqueda", busqueda);
            request.setAttribute("periodo", periodo);

            request.getRequestDispatcher("/ventaLista.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("ERROR en listarVentas: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de ventas: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioCrear(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            System.out.println("DEBUG: Mostrando formulario de creación de venta");

            List<Cliente> clientes = clienteDAO.obtenerTodosLosClientes();
            List<Producto> productos = productoDAO.obtenerTodosLosProductos();

            request.setAttribute("clientes", clientes);
            request.setAttribute("productos", productos);
            request.setAttribute("fechaActual", LocalDate.now());

            request.getRequestDispatcher("/ventaFormulario.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("ERROR en mostrarFormularioCrear: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar formulario de creación: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventas");
                return;
            }

            int id = Integer.parseInt(idParam);
            System.out.println("DEBUG: Editando venta ID: " + id);

            Venta venta = ventaDAO.obtenerVentaPorId(id);

            if (venta == null) {
                request.setAttribute("error", "Venta no encontrada");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            List<Cliente> clientes = clienteDAO.obtenerTodosLosClientes();
            List<Producto> productos = productoDAO.obtenerTodosLosProductos();

            request.setAttribute("venta", venta);
            request.setAttribute("clientes", clientes);
            request.setAttribute("productos", productos);

            request.getRequestDispatcher("/ventaFormulario.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("ERROR en mostrarFormularioEditar: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar formulario de edición: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void mostrarDetalleVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ventas");
                return;
            }

            int id = Integer.parseInt(idParam);
            System.out.println("DEBUG: Mostrando detalle de venta ID: " + id);

            Venta venta = ventaDAO.obtenerVentaPorId(id);

            if (venta == null) {
                request.setAttribute("error", "Venta no encontrada");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            request.setAttribute("venta", venta);
            request.getRequestDispatcher("/ventaDetalle.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("ERROR en mostrarDetalleVenta: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar detalle de venta: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void guardarVenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {
            System.out.println("DEBUG: Guardando nueva venta");

            Venta venta = new Venta();

            venta.setIdcliente(Integer.parseInt(request.getParameter("clienteId")));
            venta.setFecha(LocalDate.parse(request.getParameter("fecha")));
            venta.setMetodoPago(request.getParameter("metodoPago"));
            venta.setEstado(request.getParameter("estado"));
            venta.setNotas(request.getParameter("notas"));

            venta.setIdempleado(1);

            List<VentaDetalle> detalles = new ArrayList<>();
            String[] productoIds = request.getParameterValues("productoId");
            String[] cantidades = request.getParameterValues("cantidad");
            String[] precios = request.getParameterValues("precioUnitario");

            BigDecimal subtotal = BigDecimal.ZERO;

            if (productoIds != null) {
                for (int i = 0; i < productoIds.length; i++) {
                    if (productoIds[i] != null && !productoIds[i].isEmpty()) {
                        VentaDetalle detalle = new VentaDetalle();
                        detalle.setIdproducto(Integer.parseInt(productoIds[i]));
                        detalle.setCantidad(Integer.parseInt(cantidades[i]));

                        String precioLimpio = precios[i].replace("$", "").replace(".", "").replace(",", ".");
                        detalle.setPrecioUnitario(new BigDecimal(precioLimpio));

                        detalle.calcularTotal();
                        detalles.add(detalle);
                        subtotal = subtotal.add(detalle.getTotal());
                    }
                }
            }

            venta.setDetalles(detalles);
            venta.setSubtotal(subtotal);

            // Calcular impuestos y totales
            BigDecimal descuento = BigDecimal.ZERO; 
            BigDecimal iva = subtotal.multiply(new BigDecimal("0.19"));
            BigDecimal total = subtotal.add(iva).subtract(descuento);

            venta.setDescuento(descuento);
            venta.setIva(iva);
            venta.setTotal(total);

            // DEBUG: Mostrar datos antes de guardar
            System.out.println("DEBUG: Guardando venta - Subtotal: " + subtotal + ", IVA: " + iva + ", Total: " + total);

            boolean exito = ventaDAO.crearVenta(venta);

            if (exito) {
                session.setAttribute("mensaje", "Venta registrada exitosamente: " + venta.getNumeroFactura());
                response.sendRedirect(request.getContextPath() + "/ventas");
            } else {
                throw new Exception("No se pudo guardar la venta en la base de datos");
            }

        } catch (Exception e) {
            System.out.println("ERROR en guardarVenta: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error al guardar venta: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ventas/crear");
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
                response.sendRedirect(request.getContextPath() + "/ventas");
                return;
            }

            int id = Integer.parseInt(idParam);
            System.out.println("DEBUG: Cambiando estado de venta ID: " + id + " a: " + nuevoEstado);

            boolean exito = ventaDAO.actualizarEstado(id, nuevoEstado);

            if (exito) {
                session.setAttribute("mensaje", "Estado de venta actualizado exitosamente");
            } else {
                session.setAttribute("error", "No se pudo actualizar el estado de la venta");
            }

            response.sendRedirect(request.getContextPath() + "/ventas");

        } catch (Exception e) {
            System.out.println("ERROR en cambiarEstado: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error al cambiar estado: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ventas");
        }
    }
}
