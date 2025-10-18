package sistemacv.dao;

import portalempleado.utilidades.BasedeDatos;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import portalempleadosmodelo.Cliente;
import portalempleadosmodelo.Cotizacion;
import portalempleadosmodelo.CotizacionDetalle;
import portalempleadosmodelo.Producto;

public class CotizacionDAO {

    private static final Logger logger = Logger.getLogger(CotizacionDAO.class.getName());

    private String generarNumeroCotizacion(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM cotizaciones WHERE YEAR(fecha_creacion) = YEAR(NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int total = rs.getInt("total") + 1;
                return String.format("COT-%d-%05d", LocalDate.now().getYear(), total);
            }
        }
        return "COT-" + LocalDate.now().getYear() + "-00001";
    }

    public boolean crearCotizacion(Cotizacion cotizacion) {
        Connection conn = null;
        PreparedStatement stmtCotizacion = null;
        PreparedStatement stmtDetalle = null;

        try {
            conn = BasedeDatos.getConnection();
            conn.setAutoCommit(false);

            String numeroCotizacion = generarNumeroCotizacion(conn);
            cotizacion.setNumeroCotizacion(numeroCotizacion);

            String sqlCotizacion = "INSERT INTO cotizaciones (idcliente, idempleado, fecha, valido_hasta, "
                    + "proyecto, notas, terminos, subtotal, descuento, iva, total, estado) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmtCotizacion = conn.prepareStatement(sqlCotizacion, Statement.RETURN_GENERATED_KEYS);
            stmtCotizacion.setInt(1, cotizacion.getClienteId());
            stmtCotizacion.setInt(2, cotizacion.getUsuarioId());
            stmtCotizacion.setDate(3, Date.valueOf(cotizacion.getFecha()));
            stmtCotizacion.setDate(4, Date.valueOf(cotizacion.getValidoHasta()));
            stmtCotizacion.setString(5, cotizacion.getProyecto());
            stmtCotizacion.setString(6, cotizacion.getNotas());
            stmtCotizacion.setString(7, cotizacion.getTerminos());
            stmtCotizacion.setBigDecimal(8, cotizacion.getSubtotal());
            stmtCotizacion.setBigDecimal(9, cotizacion.getDescuento());
            stmtCotizacion.setBigDecimal(10, cotizacion.getIva());
            stmtCotizacion.setBigDecimal(11, cotizacion.getTotal());
            stmtCotizacion.setString(12, cotizacion.getEstado());

            int filasAfectadas = stmtCotizacion.executeUpdate();

            if (filasAfectadas == 0) {
                throw new SQLException("Error al crear cotización, ninguna fila afectada.");
            }

            try (ResultSet generatedKeys = stmtCotizacion.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int cotizacionId = generatedKeys.getInt(1);
                    cotizacion.setId(cotizacionId);

                    String sqlDetalle = "INSERT INTO cotizacion_detalles (idcotizacion, idproducto, cantidad, "
                            + "precio_unitario, descuento_porcentaje, descuento_monto, total) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

                    stmtDetalle = conn.prepareStatement(sqlDetalle);

                    for (CotizacionDetalle detalle : cotizacion.getDetalles()) {
                        stmtDetalle.setInt(1, cotizacionId);
                        stmtDetalle.setInt(2, detalle.getProductoId());
                        stmtDetalle.setInt(3, detalle.getCantidad());
                        stmtDetalle.setBigDecimal(4, detalle.getPrecioUnitario());
                        stmtDetalle.setBigDecimal(5, detalle.getDescuentoPorcentaje());
                        stmtDetalle.setBigDecimal(6, detalle.getDescuentoMonto());
                        stmtDetalle.setBigDecimal(7, detalle.getTotal());
                        stmtDetalle.addBatch();
                    }

                    stmtDetalle.executeBatch();
                    conn.commit();
                    return true;
                } else {
                    throw new SQLException("Error al obtener ID de la cotización.");
                }
            }

        } catch (SQLException e) {
            BasedeDatos.rollbackSeguro(conn);
            logger.log(Level.SEVERE, "Error al crear cotización", e);
            return false;
        } finally {
            BasedeDatos.cerrarRecursos(stmtDetalle, stmtCotizacion, conn);
        }
    }

    public List<Cotizacion> obtenerTodasLasCotizaciones() {
        List<Cotizacion> cotizaciones = new ArrayList<>();

        String sql = "SELECT c.*, "
                + "CONCAT(cl.nombre, ' ', cl.apellido) as cliente_nombre_completo, "
                + "cl.correo_electronico as cliente_correo, "
                + "cl.celular as cliente_celular, "
                + "e.usuario as empleado_usuario "
                + "FROM cotizaciones c "
                + "LEFT JOIN clientes cl ON c.idcliente = cl.idcliente "
                + "LEFT JOIN portalempleados e ON c.idempleado = e.idempleado "
                + "ORDER BY c.fecha_creacion DESC";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cotizacion cotizacion = mapearCotizacion(rs);

                Cliente cliente = new Cliente();
                cliente.setIdcliente(rs.getInt("idcliente"));
                cliente.setNombre(rs.getString("cliente_nombre_completo"));
                cliente.setCorreoElectronico(rs.getString("cliente_correo"));
                cliente.setCelular(rs.getString("cliente_celular"));
                cotizacion.setCliente(cliente);

                cotizaciones.add(cotizacion);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener cotizaciones", e);
            e.printStackTrace();
        }

        return cotizaciones;
    }

    public Cotizacion obtenerCotizacionPorId(int id) {

        String sql = "SELECT c.*, "
                + "CONCAT(cl.nombre, ' ', cl.apellido) as cliente_nombre_completo, "
                + "cl.correo_electronico as cliente_correo, "
                + "cl.celular as cliente_celular, "
                + "cl.direccion as cliente_direccion, "
                + "cl.ciudad as cliente_ciudad, "
                + "e.usuario as empleado_usuario "
                + "FROM cotizaciones c "
                + "LEFT JOIN clientes cl ON c.idcliente = cl.idcliente "
                + "LEFT JOIN portalempleados e ON c.idempleado = e.idempleado "
                + "WHERE c.idcotizacion = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Cotizacion cotizacion = mapearCotizacion(rs);

                    Cliente cliente = new Cliente();
                    cliente.setIdcliente(rs.getInt("idcliente"));
                    cliente.setNombre(rs.getString("cliente_nombre_completo"));
                    cliente.setCorreoElectronico(rs.getString("cliente_correo"));
                    cliente.setCelular(rs.getString("cliente_celular"));
                    cliente.setDireccion(rs.getString("cliente_direccion"));
                    cliente.setCiudad(rs.getString("cliente_ciudad"));
                    cotizacion.setCliente(cliente);

                    cotizacion.setDetalles(obtenerDetallesPorCotizacionId(conn, id));

                    return cotizacion;
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener cotización por ID: " + id, e);
            e.printStackTrace();
        }

        return null;
    }

    private List<CotizacionDetalle> obtenerDetallesPorCotizacionId(Connection conn, int cotizacionId) throws SQLException {
        List<CotizacionDetalle> detalles = new ArrayList<>();
        String sql = "SELECT cd.*, p.nombre as producto_nombre, p.descripcion as producto_descripcion "
                + "FROM cotizacion_detalles cd "
                + "LEFT JOIN productos p ON cd.idproducto = p.idproducto "
                + "WHERE cd.idcotizacion = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cotizacionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CotizacionDetalle detalle = new CotizacionDetalle();
                    detalle.setId(rs.getInt("id"));
                    detalle.setCotizacionId(rs.getInt("idcotizacion"));
                    detalle.setProductoId(rs.getInt("idproducto"));
                    detalle.setCantidad(rs.getInt("cantidad"));
                    detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                    detalle.setDescuentoPorcentaje(rs.getBigDecimal("descuento_porcentaje"));
                    detalle.setDescuentoMonto(rs.getBigDecimal("descuento_monto"));
                    detalle.setTotal(rs.getBigDecimal("total"));

                    Producto producto = new Producto();
                    producto.setId(rs.getInt("idproducto"));
                    producto.setNombre(rs.getString("producto_nombre"));
                    producto.setDescripcion(rs.getString("producto_descripcion"));
                    detalle.setProducto(producto);

                    detalles.add(detalle);
                }
            }
        }

        return detalles;
    }

    private Cotizacion mapearCotizacion(ResultSet rs) throws SQLException {
        Cotizacion cotizacion = new Cotizacion();

        cotizacion.setId(rs.getInt("idcotizacion"));
        cotizacion.setNumeroCotizacion("COT-" + rs.getInt("idcotizacion"));
        cotizacion.setClienteId(rs.getInt("idcliente"));
        cotizacion.setFecha(rs.getDate("fecha").toLocalDate());
        cotizacion.setValidoHasta(rs.getDate("valido_hasta").toLocalDate());
        cotizacion.setProyecto(rs.getString("proyecto"));
        cotizacion.setNotas(rs.getString("notas"));
        cotizacion.setTerminos(rs.getString("terminos"));
        cotizacion.setSubtotal(rs.getBigDecimal("subtotal"));
        cotizacion.setDescuento(rs.getBigDecimal("descuento"));
        cotizacion.setIva(rs.getBigDecimal("iva"));
        cotizacion.setTotal(rs.getBigDecimal("total"));
        cotizacion.setEstado(rs.getString("estado"));
        cotizacion.setFechaCreacion(rs.getTimestamp("fecha_creacion").toLocalDateTime());

        cotizacion.setUsuarioId(rs.getInt("idempleado"));

        return cotizacion;
    }

    public boolean actualizarEstado(int cotizacionId, String nuevoEstado) {
        String sql = "UPDATE cotizaciones SET estado = ? WHERE idcotizacion = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, cotizacionId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al actualizar estado de cotización: " + cotizacionId, e);
            return false;
        }
    }

    public int obtenerCotizacionesHoy() {
        String sql = "SELECT COUNT(*) as total FROM cotizaciones WHERE DATE(fecha_creacion) = CURDATE()";
        return obtenerConteo(sql);
    }

    public int obtenerCotizacionesPendientes() {
        String sql = "SELECT COUNT(*) as total FROM cotizaciones WHERE estado = 'PENDIENTE'";
        return obtenerConteo(sql);
    }

    public int obtenerCotizacionesAprobadas() {
        String sql = "SELECT COUNT(*) as total FROM cotizaciones WHERE estado = 'APROBADA'";
        return obtenerConteo(sql);
    }

    public BigDecimal obtenerValorTotal() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM cotizaciones WHERE estado IN ('PENDIENTE', 'APROBADA')";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener valor total de cotizaciones", e);
        }

        return BigDecimal.ZERO;
    }

    private int obtenerConteo(String sql) {
        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener conteo", e);
        }

        return 0;
    }
}
