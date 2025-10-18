package sistemacv.dao;

import portalempleadosmodelo.Producto;
import portalempleado.utilidades.BasedeDatos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductoDAO {

    private static final Logger logger = Logger.getLogger(ProductoDAO.class.getName());

    public List<Producto> obtenerTodosLosProductos() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre, pr.nombre as proveedor_nombre "
                + "FROM productos p "
                + "LEFT JOIN categorias c ON p.categoria_id = c.idcategoria " 
                + "LEFT JOIN proveedores pr ON p.proveedor_id = pr.idproveedor " 
                + "ORDER BY p.nombre";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Producto producto = mapearProducto(rs);
                productos.add(producto);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener productos", e);
        }

        return productos;
    }

    public Producto obtenerProductoPorId(int id) {
        String sql = "SELECT p.*, c.nombre as categoria_nombre, pr.nombre as proveedor_nombre "
                + "FROM productos p "
                + "LEFT JOIN categorias c ON p.categoria_id = c.idcategoria " 
                + "LEFT JOIN proveedores pr ON p.proveedor_id = pr.idproveedor " 
                + "WHERE p.idproducto = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearProducto(rs);
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener producto por ID: " + id, e);
        }

        return null;
    }

    public List<Producto> buscarProductosPorNombre(String nombre) {
        List<Producto> productos = new ArrayList<>();

        String sql = "SELECT p.*, c.nombre as categoria_nombre, pr.nombre as proveedor_nombre "
                + "FROM productos p "
                + "LEFT JOIN categorias c ON p.categoria_id = c.idcategoria " 
                + "LEFT JOIN proveedores pr ON p.proveedor_id = pr.idproveedor " 
                + "WHERE p.nombre LIKE ? ORDER BY p.nombre";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + nombre + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Producto producto = mapearProducto(rs);
                    productos.add(producto);
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al buscar productos por nombre: " + nombre, e);
        }

        return productos;
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto producto = new Producto();

        producto.setId(rs.getInt("idproducto"));
        producto.setCodigo(rs.getString("codigo"));
        producto.setNombre(rs.getString("nombre"));
        producto.setDescripcion(rs.getString("descripcion"));
        producto.setColor(rs.getString("color"));
        producto.setCategoriaId(rs.getInt("categoria_id"));
        producto.setPrecio(rs.getBigDecimal("precio"));
        producto.setMt(rs.getString("MT"));
        producto.setStock(rs.getInt("stock"));
        producto.setUbicacion(rs.getString("ubicacion"));
        producto.setProveedorId(rs.getInt("proveedor_id"));
        producto.setAcabado(rs.getString("acabado"));
        producto.setTrafico(rs.getString("trafico"));

        String rectificadoStr = rs.getString("rectificado");
        producto.setRectificado("1".equals(rectificadoStr) || "R".equals(rectificadoStr) || "true".equalsIgnoreCase(rectificadoStr));

        producto.setImagen(rs.getString("imagen"));

        if (rs.getString("categoria_nombre") != null) {
            producto.setCategoriaNombre(rs.getString("categoria_nombre"));
        }

        if (rs.getString("proveedor_nombre") != null) {
            producto.setProveedorNombre(rs.getString("proveedor_nombre"));
        }

        Date fechaCreacion = rs.getDate("fecha_creacion");
        if (fechaCreacion != null) {
            producto.setFechaCreacion(fechaCreacion.toLocalDate().atStartOfDay());
        }

        Timestamp fechaActualizacion = rs.getTimestamp("fecha_actualizacion");
        if (fechaActualizacion != null) {
            producto.setFechaActualizacion(fechaActualizacion.toLocalDateTime());
        }

        return producto;
    }

    public boolean actualizarStock(int productoId, int cantidadVendida) {

        String sql = "UPDATE productos SET stock = stock - ? WHERE idproducto = ? AND stock >= ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cantidadVendida);
            stmt.setInt(2, productoId);
            stmt.setInt(3, cantidadVendida);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al actualizar stock del producto: " + productoId, e);
            return false;
        }
    }

    public boolean crearProducto(Producto producto) {
        String sql = "INSERT INTO productos (codigo, nombre, descripcion, color, categoria_id, precio, MT, stock, ubicacion, proveedor_id, acabado, trafico, rectificado, imagen) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, producto.getCodigo());
            stmt.setString(2, producto.getNombre());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, producto.getColor());
            stmt.setInt(5, producto.getCategoriaId());
            stmt.setBigDecimal(6, producto.getPrecio());
            stmt.setString(7, producto.getMt());
            stmt.setInt(8, producto.getStock());
            stmt.setString(9, producto.getUbicacion());
            stmt.setInt(10, producto.getProveedorId());
            stmt.setString(11, producto.getAcabado());
            stmt.setString(12, producto.getTrafico());
            stmt.setString(13, producto.isRectificado() ? "1" : "0");
            stmt.setString(14, producto.getImagen());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al crear producto", e);
            return false;
        }
    }

    public boolean actualizarProducto(Producto producto) {
        String sql = "UPDATE productos SET codigo=?, nombre=?, descripcion=?, color=?, categoria_id=?, precio=?, MT=?, stock=?, ubicacion=?, proveedor_id=?, acabado=?, trafico=?, rectificado=?, imagen=? "
                + "WHERE idproducto=?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, producto.getCodigo());
            stmt.setString(2, producto.getNombre());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, producto.getColor());
            stmt.setInt(5, producto.getCategoriaId());
            stmt.setBigDecimal(6, producto.getPrecio());
            stmt.setString(7, producto.getMt());
            stmt.setInt(8, producto.getStock());
            stmt.setString(9, producto.getUbicacion());
            stmt.setInt(10, producto.getProveedorId());
            stmt.setString(11, producto.getAcabado());
            stmt.setString(12, producto.getTrafico());
            stmt.setString(13, producto.isRectificado() ? "1" : "0");
            stmt.setString(14, producto.getImagen());
            stmt.setInt(15, producto.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al actualizar producto", e);
            return false;
        }
    }

    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM productos WHERE idproducto = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al eliminar producto: " + id, e);
            return false;
        }
    }
}
