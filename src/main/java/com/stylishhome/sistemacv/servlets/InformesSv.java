package portalempleado.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import portalempleado.modelos.InformeCotizaciones;
import portalempleado.modelos.InformePedidos;
import portalempleado.modelos.InformeVentas;
import portalempleadosmodelo.Usuario;
import sistemacv.dao.InformeDAO;

@WebServlet(name = "InformesSv", urlPatterns = {"/informes", "/informes/ventas",
    "/informes/cotizaciones", "/informes/pedidos", "/informes/exportar",
    "/informes/productos", "/informes/clientes"})
public class InformesSv extends HttpServlet {

    private InformeDAO informeDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        informeDAO = new InformeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados.jsp");
            return;
        }

        String action = request.getServletPath();

        switch (action) {
            case "/informes":
                mostrarInformesPrincipales(request, response);
                break;
            case "/informes/ventas":
                mostrarInformeVentas(request, response);
                break;
            case "/informes/cotizaciones":
                mostrarInformeCotizaciones(request, response);
                break;
            case "/informes/pedidos":
                mostrarInformePedidos(request, response);
                break;
            case "/informes/productos":
                mostrarInformeProductos(request, response);
                break;
            case "/informes/clientes":
                mostrarInformeClientes(request, response);
                break;
            default:
                mostrarInformesPrincipales(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados.jsp");
            return;
        }

        String action = request.getServletPath();

        switch (action) {
            case "/informes/exportar":
                exportarInforme(request, response);
                break;
            default:
                filtrarInformes(request, response);
                break;
        }
    }

    private void mostrarInformesPrincipales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fechas por defecto (último mes)
        LocalDate fechaFin = LocalDate.now();
        LocalDate fechaInicio = fechaFin.minusMonths(1);

        // Obtener parámetros de fechas si existen
        fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", fechaInicio);
        fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", fechaFin);

        // Obtener datos para los gráficos
        List<InformeVentas> ventas = informeDAO.obtenerVentasPorPeriodo(fechaInicio, fechaFin);
        List<InformeCotizaciones> cotizaciones = informeDAO.obtenerCotizacionesPorPeriodo(fechaInicio, fechaFin);
        List<InformePedidos> pedidos = informeDAO.obtenerPedidosPorPeriodo(fechaInicio, fechaFin);
        Map<String, Object> estadisticasVentas = informeDAO.obtenerEstadisticasVentas(fechaInicio, fechaFin);
        Map<String, Object> estadisticasCotizaciones = informeDAO.obtenerEstadisticasCotizaciones(fechaInicio, fechaFin);
        List<Map<String, Object>> productosMasVendidos = informeDAO.obtenerProductosMasVendidos(fechaInicio, fechaFin);

        // Registrar log del informe 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        informeDAO.registrarLogInforme("RESUMEN_GENERAL", fechaInicio, fechaFin, idEmpleado, "Informe principal");

        request.setAttribute("ventas", ventas);
        request.setAttribute("cotizaciones", cotizaciones);
        request.setAttribute("pedidos", pedidos);
        request.setAttribute("estadisticasVentas", estadisticasVentas);
        request.setAttribute("estadisticasCotizaciones", estadisticasCotizaciones);
        request.setAttribute("productosMasVendidos", productosMasVendidos);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        request.getRequestDispatcher("/informes.jsp").forward(request, response);
    }

    private void mostrarInformeVentas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        List<InformeVentas> ventas = informeDAO.obtenerVentasPorPeriodo(fechaInicio, fechaFin);
        Map<String, Object> estadisticas = informeDAO.obtenerEstadisticasVentas(fechaInicio, fechaFin);

        // Registrar log del informe 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        informeDAO.registrarLogInforme("INFORME_VENTAS", fechaInicio, fechaFin, idEmpleado, "Detalle de ventas");

        request.setAttribute("ventas", ventas);
        request.setAttribute("estadisticas", estadisticas);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        request.getRequestDispatcher("/informeVentas.jsp").forward(request, response);
    }

    private void mostrarInformeCotizaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        List<InformeCotizaciones> cotizaciones = informeDAO.obtenerCotizacionesPorPeriodo(fechaInicio, fechaFin);
        Map<String, Object> estadisticas = informeDAO.obtenerEstadisticasCotizaciones(fechaInicio, fechaFin);

        // Registrar log del informe 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        informeDAO.registrarLogInforme("INFORME_COTIZACIONES", fechaInicio, fechaFin, idEmpleado, "Detalle de cotizaciones");

        request.setAttribute("cotizaciones", cotizaciones);
        request.setAttribute("estadisticas", estadisticas);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        request.getRequestDispatcher("/informeCotizaciones.jsp").forward(request, response);
    }

    private void mostrarInformePedidos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        List<InformePedidos> pedidos = informeDAO.obtenerPedidosPorPeriodo(fechaInicio, fechaFin);

        // Registrar log del informe 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        informeDAO.registrarLogInforme("INFORME_PEDIDOS", fechaInicio, fechaFin, idEmpleado, "Detalle de pedidos");

        request.setAttribute("pedidos", pedidos);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        request.getRequestDispatcher("/informePedidos.jsp").forward(request, response);
    }

    private void mostrarInformeProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        List<Map<String, Object>> productosMasVendidos = informeDAO.obtenerProductosMasVendidos(fechaInicio, fechaFin);

        // Registrar log del informe 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        informeDAO.registrarLogInforme("INFORME_PRODUCTOS", fechaInicio, fechaFin, idEmpleado, "Productos más vendidos");

        request.setAttribute("productosMasVendidos", productosMasVendidos);
        request.setAttribute("fechaInicio", fechaInicio);
        request.setAttribute("fechaFin", fechaFin);

        request.getRequestDispatcher("/informeProductos.jsp").forward(request, response);
    }

    private void mostrarInformeClientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusYears(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        response.sendRedirect(request.getContextPath() + "/informes");
    }

    private void filtrarInformes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "startDate", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "endDate", LocalDate.now());
        String tipoInforme = request.getParameter("reportType");

        // Registrar log del filtro aplicado 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        String parametros = "Tipo: " + tipoInforme + ", FechaInicio: " + fechaInicio + ", FechaFin: " + fechaFin;
        informeDAO.registrarLogInforme("FILTRO_APLICADO", fechaInicio, fechaFin, idEmpleado, parametros);

        // Redirigir según el tipo de informe seleccionado
        switch (tipoInforme != null ? tipoInforme : "Resumen General") {
            case "Vendedor":
            case "Cliente":
            case "Producto":
            case "Resumen Detallado":
                response.sendRedirect(request.getContextPath() + "/informes/ventas?fechaInicio="
                        + fechaInicio + "&fechaFin=" + fechaFin);
                break;
            case "Cotización":
                response.sendRedirect(request.getContextPath() + "/informes/cotizaciones?fechaInicio="
                        + fechaInicio + "&fechaFin=" + fechaFin);
                break;
            case "Pedido":
                response.sendRedirect(request.getContextPath() + "/informes/pedidos?fechaInicio="
                        + fechaInicio + "&fechaFin=" + fechaFin);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/informes?fechaInicio="
                        + fechaInicio + "&fechaFin=" + fechaFin);
                break;
        }
    }

    private void exportarInforme(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipoExportacion = request.getParameter("tipo");
        String formato = request.getParameter("formato");
        LocalDate fechaInicio = obtenerFechaDesdeRequest(request, "fechaInicio", LocalDate.now().minusMonths(1));
        LocalDate fechaFin = obtenerFechaDesdeRequest(request, "fechaFin", LocalDate.now());

        // Registrar log de exportación 
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idEmpleado = obtenerIdEmpleadoDesdeUsuario(usuario);
        String parametros = "Tipo: " + tipoExportacion + ", Formato: " + formato;
        informeDAO.registrarLogInforme("EXPORTACION", fechaInicio, fechaFin, idEmpleado, parametros);

        // Por ahora solo redirigimos y mostramos mensaje
        request.setAttribute("mensaje", "Informe exportado exitosamente");
        request.setAttribute("tipoMensaje", "success");

        mostrarInformesPrincipales(request, response);
    }

    private LocalDate obtenerFechaDesdeRequest(HttpServletRequest request, String paramName, LocalDate defaultDate) {
        String fechaStr = request.getParameter(paramName);
        if (fechaStr != null && !fechaStr.trim().isEmpty()) {
            try {
                return LocalDate.parse(fechaStr);
            } catch (Exception e) {
                // Si hay error en el parseo, usar fecha por defecto
                System.err.println("Error parseando fecha: " + e.getMessage());
            }
        }
        return defaultDate;
    }

    // MÉTODO CORREGIDO - Ahora recibe un objeto Usuario
    private int obtenerIdEmpleadoDesdeUsuario(Usuario usuario) {
        // Si el usuario es null, retornar un ID por defecto
        if (usuario == null) {
            return 1; // ID por defecto
        }

        // Obtener el nombre de usuario del objeto Usuario
        String nombreUsuario = usuario.getUsuario(); // O el método getter apropiado

        // Método simplificado para obtener el ID del empleado
        // En una implementación real, esto debería consultar la base de datos
        Map<String, Integer> usuarios = Map.of(
                "Jsalas", 1,
                "Hsantorini", 2,
                "Nwarner", 3,
                "Aduarte", 4,
                "Shinestroza", 5,
                "Bvidal", 6
        );
        return usuarios.getOrDefault(nombreUsuario, 1);
    }
}