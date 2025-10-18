package sistemacv.dao;

import portalempleado.modelos.*;
import portalempleado.utilidades.BasedeDatos;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InformeDAO {

    private static final Logger logger = Logger.getLogger(InformeDAO.class.getName());

    // Método para obtener informe de ventas por período
    public List<InformeVentas> obtenerVentasPorPeriodo(LocalDate fechaInicio, LocalDate fechaFin) {
        List<InformeVentas> ventas = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT v.idventa, v.numero_factura, v.fecha, v.total, v.estado, v.metodo_pago,
                       CONCAT(c.nombre, ' ', c.apellido) as cliente,
                       u.usuario as vendedor,
                       p.nombre as producto, vd.cantidad, vd.precio_unitario
                FROM ventas v
                JOIN clientes c ON v.idcliente = c.idcliente
                JOIN portalempleados u ON v.idempleado = u.idempleado
                JOIN venta_detalles vd ON v.idventa = vd.idventa
                JOIN productos p ON vd.idproducto = p.idproducto
                WHERE v.fecha BETWEEN ? AND ?
                ORDER BY v.fecha DESC
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            while (rs.next()) {
                InformeVentas venta = new InformeVentas();
                venta.setId(rs.getInt("idventa"));
                venta.setNumeroFactura(rs.getString("numero_factura"));
                venta.setFecha(rs.getDate("fecha").toLocalDate());
                venta.setVendedor(rs.getString("vendedor"));
                venta.setCliente(rs.getString("cliente"));
                venta.setTotalVenta(rs.getBigDecimal("total"));
                venta.setEstado(rs.getString("estado"));
                venta.setMetodoPago(rs.getString("metodo_pago"));
                venta.setProducto(rs.getString("producto"));
                venta.setCantidad(rs.getInt("cantidad"));
                venta.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));

                ventas.add(venta);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener ventas por período", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return ventas;
    }

    // Método para obtener informe de cotizaciones por período
    public List<InformeCotizaciones> obtenerCotizacionesPorPeriodo(LocalDate fechaInicio, LocalDate fechaFin) {
        List<InformeCotizaciones> cotizaciones = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT c.idcotizacion, c.fecha, c.valido_hasta, c.total, c.estado,
                       CONCAT(cli.nombre, ' ', cli.apellido) as cliente,
                       u.usuario as vendedor,
                       p.nombre as producto, cd.cantidad, cd.precio_unitario,
                       DATEDIFF(c.valido_hasta, CURDATE()) as dias_para_vencer
                FROM cotizaciones c
                JOIN clientes cli ON c.idcliente = cli.idcliente
                JOIN portalempleados u ON c.idempleado = u.idempleado
                JOIN cotizacion_detalles cd ON c.idcotizacion = cd.idcotizacion
                JOIN productos p ON cd.idproducto = p.idproducto
                WHERE c.fecha BETWEEN ? AND ?
                ORDER BY c.fecha DESC
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            while (rs.next()) {
                InformeCotizaciones cotizacion = new InformeCotizaciones();
                cotizacion.setId(rs.getInt("idcotizacion"));
                cotizacion.setNumeroCotizacion("COT-" + rs.getInt("idcotizacion"));
                cotizacion.setFecha(rs.getDate("fecha").toLocalDate());
                cotizacion.setCliente(rs.getString("cliente"));
                cotizacion.setVendedor(rs.getString("vendedor"));
                cotizacion.setTotal(rs.getBigDecimal("total"));
                cotizacion.setEstado(rs.getString("estado"));
                cotizacion.setFechaVencimiento(rs.getDate("valido_hasta").toLocalDate());
                cotizacion.setProducto(rs.getString("producto"));
                cotizacion.setCantidad(rs.getInt("cantidad"));
                cotizacion.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                cotizacion.setDiasParaVencer(rs.getInt("dias_para_vencer"));

                cotizaciones.add(cotizacion);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener cotizaciones por período", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return cotizaciones;
    }

    // Método para obtener informe de pedidos (ventas pendientes)
    public List<InformePedidos> obtenerPedidosPorPeriodo(LocalDate fechaInicio, LocalDate fechaFin) {
        List<InformePedidos> pedidos = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT v.idventa, v.numero_factura, v.fecha, v.total, v.estado,
                       CONCAT(c.nombre, ' ', c.apellido) as cliente,
                       u.usuario as vendedor,
                       COUNT(vd.id) as cantidad_productos,
                       SUM(vd.cantidad) as total_unidades,
                       v.notas
                FROM ventas v
                JOIN clientes c ON v.idcliente = c.idcliente
                JOIN portalempleados u ON v.idempleado = u.idempleado
                LEFT JOIN venta_detalles vd ON v.idventa = vd.idventa
                WHERE v.fecha BETWEEN ? AND ?
                GROUP BY v.idventa, v.numero_factura, v.fecha, v.total, v.estado, 
                         c.nombre, c.apellido, u.usuario, v.notas
                ORDER BY v.fecha DESC
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            while (rs.next()) {
                InformePedidos pedido = new InformePedidos();
                pedido.setId(rs.getInt("idventa"));
                pedido.setNumeroPedido(rs.getString("numero_factura"));
                pedido.setFecha(rs.getDate("fecha").toLocalDate());
                pedido.setCliente(rs.getString("cliente"));
                pedido.setVendedor(rs.getString("vendedor"));
                pedido.setCantidadProductos(rs.getInt("cantidad_productos"));
                pedido.setTotal(rs.getBigDecimal("total"));
                pedido.setEstado(rs.getString("estado"));
                pedido.setNotas(rs.getString("notas"));
                pedido.setTotalUnidades(rs.getInt("total_unidades"));

                pedidos.add(pedido);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener pedidos por período", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return pedidos;
    }

    // Método para obtener estadísticas de ventas
    public Map<String, Object> obtenerEstadisticasVentas(LocalDate fechaInicio, LocalDate fechaFin) {
        Map<String, Object> estadisticas = new HashMap<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT 
                    COUNT(*) as total_ventas,
                    COALESCE(SUM(total), 0) as total_ingresos,
                    COALESCE(AVG(total), 0) as promedio_venta,
                    COALESCE(MAX(total), 0) as venta_maxima,
                    COALESCE(MIN(total), 0) as venta_minima,
                    COALESCE(SUM(CASE WHEN metodo_pago = 'EFECTIVO' THEN total ELSE 0 END), 0) as total_efectivo,
                    COALESCE(SUM(CASE WHEN metodo_pago = 'TARJETA_CREDITO' THEN total ELSE 0 END), 0) as total_tarjeta,
                    COALESCE(SUM(CASE WHEN metodo_pago = 'TRANSFERENCIA' THEN total ELSE 0 END), 0) as total_transferencia,
                    COALESCE(SUM(CASE WHEN metodo_pago = 'CHEQUE' THEN total ELSE 0 END), 0) as total_cheque
                FROM ventas 
                WHERE fecha BETWEEN ? AND ? AND estado = 'COMPLETADA'
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            if (rs.next()) {
                estadisticas.put("totalVentas", rs.getInt("total_ventas"));
                estadisticas.put("totalIngresos", rs.getBigDecimal("total_ingresos"));
                estadisticas.put("promedioVenta", rs.getBigDecimal("promedio_venta"));
                estadisticas.put("ventaMaxima", rs.getBigDecimal("venta_maxima"));
                estadisticas.put("ventaMinima", rs.getBigDecimal("venta_minima"));
                estadisticas.put("totalEfectivo", rs.getBigDecimal("total_efectivo"));
                estadisticas.put("totalTarjeta", rs.getBigDecimal("total_tarjeta"));
                estadisticas.put("totalTransferencia", rs.getBigDecimal("total_transferencia"));
                estadisticas.put("totalCheque", rs.getBigDecimal("total_cheque"));
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener estadísticas de ventas", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return estadisticas;
    }

    // Método para obtener estadísticas de cotizaciones
    public Map<String, Object> obtenerEstadisticasCotizaciones(LocalDate fechaInicio, LocalDate fechaFin) {
        Map<String, Object> estadisticas = new HashMap<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT 
                    COUNT(*) as total_cotizaciones,
                    COALESCE(SUM(total), 0) as total_valor,
                    COALESCE(AVG(total), 0) as promedio_cotizacion,
                    SUM(CASE WHEN estado = 'APROBADA' THEN 1 ELSE 0 END) as aprobadas,
                    SUM(CASE WHEN estado = 'PENDIENTE' THEN 1 ELSE 0 END) as pendientes,
                    SUM(CASE WHEN estado = 'RECHAZADA' THEN 1 ELSE 0 END) as rechazadas,
                    SUM(CASE WHEN estado = 'VENCIDA' THEN 1 ELSE 0 END) as vencidas
                FROM cotizaciones 
                WHERE fecha BETWEEN ? AND ?
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            if (rs.next()) {
                estadisticas.put("totalCotizaciones", rs.getInt("total_cotizaciones"));
                estadisticas.put("totalValor", rs.getBigDecimal("total_valor"));
                estadisticas.put("promedioCotizacion", rs.getBigDecimal("promedio_cotizacion"));
                estadisticas.put("aprobadas", rs.getInt("aprobadas"));
                estadisticas.put("pendientes", rs.getInt("pendientes"));
                estadisticas.put("rechazadas", rs.getInt("rechazadas"));
                estadisticas.put("vencidas", rs.getInt("vencidas"));
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener estadísticas de cotizaciones", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return estadisticas;
    }

    // Método para registrar log de informe generado
    public boolean registrarLogInforme(String tipoInforme, LocalDate fechaInicio, LocalDate fechaFin, int idEmpleado, String parametros) {
        Connection conexion = null;
        PreparedStatement statement = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                INSERT INTO informe_logs (tipo_informe, fecha_inicio, fecha_fin, idempleado, parametros)
                VALUES (?, ?, ?, ?, ?)
                """;

            statement = conexion.prepareStatement(sql);
            statement.setString(1, tipoInforme);
            statement.setDate(2, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(3, java.sql.Date.valueOf(fechaFin));
            statement.setInt(4, idEmpleado);
            statement.setString(5, parametros);

            int filasAfectadas = statement.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al registrar log de informe", e);
            return false;
        } finally {
            BasedeDatos.cerrarRecursos(statement, conexion);
        }
    }

    // Método para obtener productos más vendidos
    public List<Map<String, Object>> obtenerProductosMasVendidos(LocalDate fechaInicio, LocalDate fechaFin) {
        List<Map<String, Object>> productos = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            conexion = BasedeDatos.getConnection();
            String sql = """
                SELECT 
                    p.codigo,
                    p.nombre,
                    cat.nombre as categoria,
                    COALESCE(SUM(vd.cantidad), 0) as total_vendido,
                    COALESCE(SUM(vd.cantidad * vd.precio_unitario), 0) as total_ingresos
                FROM productos p
                JOIN categorias cat ON p.categoria_id = cat.idcategoria
                LEFT JOIN venta_detalles vd ON p.idproducto = vd.idproducto
                LEFT JOIN ventas v ON vd.idventa = v.idventa AND v.estado = 'COMPLETADA'
                WHERE (v.fecha IS NULL OR v.fecha BETWEEN ? AND ?)
                GROUP BY p.codigo, p.nombre, cat.nombre
                ORDER BY total_vendido DESC
                LIMIT 10
                """;

            statement = conexion.prepareStatement(sql);
            statement.setDate(1, java.sql.Date.valueOf(fechaInicio));
            statement.setDate(2, java.sql.Date.valueOf(fechaFin));

            rs = statement.executeQuery();

            while (rs.next()) {
                Map<String, Object> producto = new HashMap<>();
                producto.put("codigo", rs.getString("codigo"));
                producto.put("nombre", rs.getString("nombre"));
                producto.put("categoria", rs.getString("categoria"));
                producto.put("totalVendido", rs.getInt("total_vendido"));
                producto.put("totalIngresos", rs.getBigDecimal("total_ingresos"));
                productos.add(producto);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener productos más vendidos", e);
        } finally {
            BasedeDatos.cerrarRecursos(rs, statement, conexion);
        }

        return productos;
    }
}
