package sistemacv.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import portalempleadosmodelo.Categoria;
import portalempleadosmodelo.Producto;

public class ProductoDAO {
    private Connection connection;

    public ProductoDAO(Connection connection) {
        this.connection = connection;
    }

    public boolean crearProducto(Producto producto) throws SQLException {
        String sql = "INSERT INTO productos (codigo, nombre, descripcion, color, categoria_id, precio, " +
                    "stock, stock_minimo, ubicacion, proveedor_id, acabado, trafico, rectificado, imagen) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, producto.getCodigo());
            stmt.setString(2, producto.getNombre());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, producto.getColor());
            stmt.setInt(5, producto.getCategoriaId());
            stmt.setBigDecimal(6, producto.getPrecio());
            stmt.setInt(7, producto.getStock());
            stmt.setInt(8, producto.getStockMinimo());
            stmt.setString(9, producto.getUbicacion());
            stmt.setInt(10, producto.getProveedorId());
            stmt.setString(11, producto.getAcabado());
            stmt.setString(12, producto.getTrafico());
            stmt.setBoolean(13, producto.isRectificado());
            stmt.setString(14, producto.getImagen());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Producto> obtenerTodosProductos() throws SQLException {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT p.*, c.nombre as categoria_nombre, pr.nombre as proveedor_nombre " +
                    "FROM productos p " +
                    "LEFT JOIN categorias c ON p.categoria_id = c.id " +
                    "LEFT JOIN proveedores pr ON p.proveedor_id = pr.id " +
                    "ORDER BY p.fecha_creacion DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Producto producto = mapearProducto(rs);
                producto.setCategoriaNombre(rs.getString("categoria_nombre"));
                producto.setProveedorNombre(rs.getString("proveedor_nombre"));
                productos.add(producto);
            }
        }
        return productos;
    }

    public Producto obtenerProductoPorId(int id) throws SQLException {
        String sql = "SELECT p.*, c.nombre as categoria_nombre, pr.nombre as proveedor_nombre " +
                    "FROM productos p " +
                    "LEFT JOIN categorias c ON p.categoria_id = c.id " +
                    "LEFT JOIN proveedores pr ON p.proveedor_id = pr.id " +
                    "WHERE p.id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Producto producto = mapearProducto(rs);
                producto.setCategoriaNombre(rs.getString("categoria_nombre"));
                producto.setProveedorNombre(rs.getString("proveedor_nombre"));
                return producto;
            }
        }
        return null;
    }

    public boolean actualizarProducto(Producto producto) throws SQLException {
        String sql = "UPDATE productos SET codigo=?, nombre=?, descripcion=?, color=?, " +
                    "categoria_id=?, precio=?, stock=?, stock_minimo=?, ubicacion=?, " +
                    "proveedor_id=?, acabado=?, trafico=?, rectificado=?, imagen=?, " +
                    "fecha_actualizacion=CURRENT_TIMESTAMP WHERE id=?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, producto.getCodigo());
            stmt.setString(2, producto.getNombre());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, producto.getColor());
            stmt.setInt(5, producto.getCategoriaId());
            stmt.setBigDecimal(6, producto.getPrecio());
            stmt.setInt(7, producto.getStock());
            stmt.setInt(8, producto.getStockMinimo());
            stmt.setString(9, producto.getUbicacion());
            stmt.setInt(10, producto.getProveedorId());
            stmt.setString(11, producto.getAcabado());
            stmt.setString(12, producto.getTrafico());
            stmt.setBoolean(13, producto.isRectificado());
            stmt.setString(14, producto.getImagen());
            stmt.setInt(15, producto.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean eliminarProducto(int id) throws SQLException {
        String sql = "DELETE FROM productos WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Categoria> obtenerCategorias() throws SQLException {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "SELECT * FROM categorias ORDER BY nombre";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Categoria categoria = new Categoria(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("descripcion")
                );
                categorias.add(categoria);
            }
        }
        return categorias;
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto producto = new Producto();
        producto.setId(rs.getInt("id"));
        producto.setCodigo(rs.getString("codigo"));
        producto.setNombre(rs.getString("nombre"));
        producto.setDescripcion(rs.getString("descripcion"));
        producto.setColor(rs.getString("color"));
        producto.setCategoriaId(rs.getInt("categoria_id"));
        producto.setPrecio(rs.getBigDecimal("precio"));
        producto.setStock(rs.getInt("stock"));
        producto.setStockMinimo(rs.getInt("stock_minimo"));
        producto.setUbicacion(rs.getString("ubicacion"));
        producto.setProveedorId(rs.getInt("proveedor_id"));
        producto.setAcabado(rs.getString("acabado"));
        producto.setTrafico(rs.getString("trafico"));
        producto.setRectificado(rs.getBoolean("rectificado"));
        producto.setImagen(rs.getString("imagen"));
        producto.setFechaCreacion(rs.getTimestamp("fecha_creacion") != null ? 
            rs.getTimestamp("fecha_creacion").toLocalDateTime() : null);
        producto.setFechaActualizacion(rs.getTimestamp("fecha_actualizacion") != null ? 
            rs.getTimestamp("fecha_actualizacion").toLocalDateTime() : null);
        
        return producto;
    }
}


