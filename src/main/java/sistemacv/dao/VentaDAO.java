package sistemacv.dao;

import portalempleado.utilidades.BasedeDatos;
import portalempleadosmodelo.Venta;
import portalempleadosmodelo.VentaDetalle;
import portalempleadosmodelo.Cliente;
import portalempleadosmodelo.Producto;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VentaDAO {

    private static final Logger logger = Logger.getLogger(VentaDAO.class.getName());

    private String generarNumeroFactura(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM ventas WHERE YEAR(fecha_creacion) = YEAR(NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int total = rs.getInt("total") + 1;
                return String.format("FAC-%d-%05d", LocalDate.now().getYear(), total);
            }
        }
        return "FAC-" + LocalDate.now().getYear() + "-00001";
    }

    public boolean crearVenta(Venta venta) {
        Connection conn = null;
        PreparedStatement stmtVenta = null;
        PreparedStatement stmtDetalle = null;

        try {
            conn = BasedeDatos.getConnection();
            conn.setAutoCommit(false);

            String numeroFactura = generarNumeroFactura(conn);
            venta.setNumeroFactura(numeroFactura);

            String sqlVenta = "INSERT INTO ventas (idcliente, idempleado, fecha, metodo_pago, estado, "
                    + "subtotal, descuento, iva, total, notas) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmtVenta = conn.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            stmtVenta.setInt(1, venta.getIdcliente());
            stmtVenta.setInt(2, venta.getIdempleado());
            stmtVenta.setDate(3, Date.valueOf(venta.getFecha()));
            stmtVenta.setString(4, venta.getMetodoPago());
            stmtVenta.setString(5, venta.getEstado());
            stmtVenta.setBigDecimal(6, venta.getSubtotal());
            stmtVenta.setBigDecimal(7, venta.getDescuento());
            stmtVenta.setBigDecimal(8, venta.getIva());
            stmtVenta.setBigDecimal(9, venta.getTotal());
            stmtVenta.setString(10, venta.getNotas());

            int filasAfectadas = stmtVenta.executeUpdate();

            if (filasAfectadas == 0) {
                throw new SQLException("Error al crear venta, ninguna fila afectada.");
            }

            try (ResultSet generatedKeys = stmtVenta.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int ventaId = generatedKeys.getInt(1);
                    venta.setIdventa(ventaId);

                    String sqlDetalle = "INSERT INTO venta_detalles (idventa, idproducto, cantidad, "
                            + "precio_unitario, total) VALUES (?, ?, ?, ?, ?)";

                    stmtDetalle = conn.prepareStatement(sqlDetalle);

                    for (VentaDetalle detalle : venta.getDetalles()) {
                        stmtDetalle.setInt(1, ventaId);
                        stmtDetalle.setInt(2, detalle.getIdproducto());
                        stmtDetalle.setInt(3, detalle.getCantidad());
                        stmtDetalle.setBigDecimal(4, detalle.getPrecioUnitario());
                        stmtDetalle.setBigDecimal(5, detalle.getTotal());
                        stmtDetalle.addBatch();
                    }

                    stmtDetalle.executeBatch();
                    conn.commit();
                    return true;
                } else {
                    throw new SQLException("Error al obtener ID de la venta.");
                }
            }

        } catch (SQLException e) {
            BasedeDatos.rollbackSeguro(conn);
            logger.log(Level.SEVERE, "Error al crear venta", e);
            return false;
        } finally {
            BasedeDatos.cerrarRecursos(stmtDetalle, stmtVenta, conn);
        }
    }

    public List<Venta> obtenerTodasLasVentas() {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT v.*, "
                + "CONCAT(cl.nombre, ' ', cl.apellido) as cliente_nombre_completo, "
                + "cl.correo_electronico as cliente_correo, "
                + "cl.celular as cliente_celular, "
                + "e.usuario as empleado_usuario "
                + "FROM ventas v "
                + "LEFT JOIN clientes cl ON v.idcliente = cl.idcliente "
                + "LEFT JOIN portalempleados e ON v.idempleado = e.idempleado "
                + "ORDER BY v.fecha_creacion DESC";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Venta venta = mapearVenta(rs);

                Cliente cliente = new Cliente();
                cliente.setIdcliente(rs.getInt("idcliente"));
                cliente.setNombre(rs.getString("cliente_nombre_completo"));
                cliente.setCorreoElectronico(rs.getString("cliente_correo"));
                cliente.setCelular(rs.getString("cliente_celular"));
                venta.setCliente(cliente);

                ventas.add(venta);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener ventas", e);
        }

        return ventas;
    }

    public Venta obtenerVentaPorId(int id) {
        String sql = "SELECT v.*, "
                + "CONCAT(cl.nombre, ' ', cl.apellido) as cliente_nombre_completo, "
                + "cl.correo_electronico as cliente_correo, "
                + "cl.celular as cliente_celular, "
                + "cl.direccion as cliente_direccion, "
                + "cl.ciudad as cliente_ciudad, "
                + "e.usuario as empleado_usuario "
                + "FROM ventas v "
                + "LEFT JOIN clientes cl ON v.idcliente = cl.idcliente "
                + "LEFT JOIN portalempleados e ON v.idempleado = e.idempleado "
                + "WHERE v.idventa = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Venta venta = mapearVenta(rs);

                    Cliente cliente = new Cliente();
                    cliente.setIdcliente(rs.getInt("idcliente"));
                    cliente.setNombre(rs.getString("cliente_nombre_completo"));
                    cliente.setCorreoElectronico(rs.getString("cliente_correo"));
                    cliente.setCelular(rs.getString("cliente_celular"));
                    cliente.setDireccion(rs.getString("cliente_direccion"));
                    cliente.setCiudad(rs.getString("cliente_ciudad"));
                    venta.setCliente(cliente);

                    venta.setDetalles(obtenerDetallesPorVentaId(conn, id));

                    return venta;
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener venta por ID: " + id, e);
        }

        return null;
    }

    private List<VentaDetalle> obtenerDetallesPorVentaId(Connection conn, int ventaId) throws SQLException {
        List<VentaDetalle> detalles = new ArrayList<>();
        String sql = "SELECT vd.*, p.nombre as producto_nombre, p.descripcion as producto_descripcion, "
                + "p.imagen as producto_imagen "
                + "FROM venta_detalles vd "
                + "LEFT JOIN productos p ON vd.idproducto = p.idproducto "
                + "WHERE vd.idventa = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ventaId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    VentaDetalle detalle = new VentaDetalle();
                    detalle.setId(rs.getInt("id"));
                    detalle.setIdventa(rs.getInt("idventa"));
                    detalle.setIdproducto(rs.getInt("idproducto"));
                    detalle.setCantidad(rs.getInt("cantidad"));
                    detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                    detalle.setTotal(rs.getBigDecimal("total"));

                    Producto producto = new Producto();
                    producto.setId(rs.getInt("idproducto"));
                    producto.setNombre(rs.getString("producto_nombre"));
                    producto.setDescripcion(rs.getString("producto_descripcion"));
                    producto.setImagen(rs.getString("producto_imagen"));
                    detalle.setProducto(producto);

                    detalles.add(detalle);
                }
            }
        }

        return detalles;
    }

    private Venta mapearVenta(ResultSet rs) throws SQLException {
        Venta venta = new Venta();
        venta.setIdventa(rs.getInt("idventa"));
        venta.setNumeroFactura(rs.getString("numero_factura"));
        venta.setIdcliente(rs.getInt("idcliente"));
        venta.setIdempleado(rs.getInt("idempleado"));
        venta.setFecha(rs.getDate("fecha").toLocalDate());
        venta.setMetodoPago(rs.getString("metodo_pago"));
        venta.setEstado(rs.getString("estado"));
        venta.setSubtotal(rs.getBigDecimal("subtotal"));
        venta.setDescuento(rs.getBigDecimal("descuento"));
        venta.setIva(rs.getBigDecimal("iva"));
        venta.setTotal(rs.getBigDecimal("total"));
        venta.setNotas(rs.getString("notas"));
        venta.setFechaCreacion(rs.getTimestamp("fecha_creacion").toLocalDateTime());

        return venta;
    }

    public boolean actualizarEstado(int ventaId, String nuevoEstado) {
        String sql = "UPDATE ventas SET estado = ? WHERE idventa = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, ventaId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al actualizar estado de venta: " + ventaId, e);
            return false;
        }
    }

    public BigDecimal obtenerVentasHoy() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM ventas WHERE DATE(fecha) = CURDATE()";
        return obtenerTotal(sql);
    }

    public BigDecimal obtenerVentasMensuales() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM ventas WHERE MONTH(fecha) = MONTH(CURDATE()) AND YEAR(fecha) = YEAR(CURDATE())";
        return obtenerTotal(sql);
    }

    public BigDecimal obtenerVentasAnuales() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM ventas WHERE YEAR(fecha) = YEAR(CURDATE())";
        return obtenerTotal(sql);
    }

    public BigDecimal obtenerMetaMensual() {
        return new BigDecimal("118680000");
    }

    private BigDecimal obtenerTotal(String sql) {
        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("total");
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener total de ventas", e);
        }

        return BigDecimal.ZERO;
    }

    public List<Producto> obtenerProductosMasVendidos() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT p.*, SUM(vd.cantidad) as total_vendido "
                + "FROM venta_detalles vd "
                + "LEFT JOIN productos p ON vd.idproducto = p.idproducto "
                + "GROUP BY p.idproducto, p.nombre, p.descripcion, p.imagen "
                + "ORDER BY total_vendido DESC "
                + "LIMIT 5";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Producto producto = new Producto();

                producto.setId(rs.getInt("idproducto"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setImagen(rs.getString("imagen"));

                productos.add(producto);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener productos más vendidos", e);
        }

        return productos;
    }
}
