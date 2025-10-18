package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import portalempleadosmodelo.Categoria;
import portalempleado.utilidades.BasedeDatos;
import portalempleadosmodelo.Producto;

@WebServlet(name = "ProductosSv", urlPatterns = {"/productos"})
public class ProductosSv extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/portalempleados");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("lista")) {
                mostrarListaProductos(request, response);
            } else if (action.equals("ver")) {
                mostrarDetalleProducto(request, response);
            } else {
                mostrarListaProductos(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/productos?error=Error al procesar la solicitud");
        }
    }

    private void mostrarListaProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtCategorias = null;
        ResultSet rs = null;
        ResultSet rsCategorias = null;

        try {
            conn = BasedeDatos.getConnection();

            String busqueda = request.getParameter("busqueda");
            String categoriaId = request.getParameter("categoria");

            StringBuilder sql = new StringBuilder(
                    "SELECT p.idproducto, p.codigo, p.nombre, p.descripcion, p.color, "
                    + "p.categoria_id, p.precio, p.MT, p.stock, p.ubicacion, "
                    + "p.proveedor_id, p.acabado, p.trafico, p.rectificado, p.imagen, "
                    + "p.fecha_creacion, p.fecha_actualizacion, "
                    + "c.nombre as categoria_nombre, pr.nombre as proveedor_nombre "
                    + "FROM productos p "
                    + "LEFT JOIN categorias c ON p.categoria_id = c.idcategoria "
                    + "LEFT JOIN proveedores pr ON p.proveedor_id = pr.idproveedor " 
                    + "WHERE 1=1"
            );

            List<Object> parametros = new ArrayList<>();

            if (busqueda != null && !busqueda.trim().isEmpty()) {
                sql.append(" AND (p.nombre LIKE ? OR p.codigo LIKE ? OR p.descripcion LIKE ?)");
                String likeParam = "%" + busqueda.trim() + "%";
                parametros.add(likeParam);
                parametros.add(likeParam);
                parametros.add(likeParam);
            }

            if (categoriaId != null && !categoriaId.trim().isEmpty()) {
                sql.append(" AND p.categoria_id = ?");
                parametros.add(Integer.parseInt(categoriaId));
            }

            sql.append(" ORDER BY p.fecha_creacion DESC");

            pstmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < parametros.size(); i++) {
                pstmt.setObject(i + 1, parametros.get(i));
            }

            rs = pstmt.executeQuery();

            List<Producto> productos = new ArrayList<>();

            while (rs.next()) {
                Producto producto = new Producto();

                producto.setId(rs.getInt("idproducto")); 
                producto.setCodigo(rs.getString("codigo"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setColor(rs.getString("color"));
                producto.setCategoriaId(rs.getInt("categoria_id"));
                producto.setPrecio(rs.getBigDecimal("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setUbicacion(rs.getString("ubicacion"));
                producto.setProveedorId(rs.getInt("proveedor_id"));
                producto.setAcabado(rs.getString("acabado"));
                producto.setTrafico(rs.getString("trafico"));

                String rectificadoStr = rs.getString("rectificado");
                producto.setRectificado("1".equals(rectificadoStr) || "R".equals(rectificadoStr) || "true".equalsIgnoreCase(rectificadoStr));

                producto.setImagen(rs.getString("imagen"));

                java.sql.Date fechaCreacion = rs.getDate("fecha_creacion");
                java.sql.Timestamp fechaActualizacion = rs.getTimestamp("fecha_actualizacion");

                if (fechaCreacion != null) {
                    producto.setFechaCreacion(fechaCreacion.toLocalDate().atStartOfDay());
                }
                if (fechaActualizacion != null) {
                    producto.setFechaActualizacion(fechaActualizacion.toLocalDateTime());
                }

                producto.setCategoriaNombre(rs.getString("categoria_nombre"));
                producto.setProveedorNombre(rs.getString("proveedor_nombre"));

                productos.add(producto);
            }

            String sqlCategorias = "SELECT idcategoria as id, nombre FROM categorias ORDER BY nombre";
            pstmtCategorias = conn.prepareStatement(sqlCategorias);
            rsCategorias = pstmtCategorias.executeQuery();

            List<Categoria> categorias = new ArrayList<>();

            while (rsCategorias.next()) {
                Categoria categoria = new Categoria();
                categoria.setId(rsCategorias.getInt("id"));
                categoria.setNombre(rsCategorias.getString("nombre"));
                categorias.add(categoria);
            }

            request.setAttribute("productos", productos);
            request.setAttribute("categorias", categorias);
            request.getRequestDispatcher("/productoLista.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de productos: " + e.getMessage());
            request.getRequestDispatcher("/productoLista.jsp").forward(request, response);
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt, rs);
            BasedeDatos.cerrarRecursos(null, pstmtCategorias, rsCategorias);
        }
    }

    private void mostrarDetalleProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idProducto = request.getParameter("id");

        if (idProducto == null || idProducto.isEmpty()) {
            response.sendRedirect("productos?error=ID de producto no válido");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = BasedeDatos.getConnection();

            String sql = "SELECT p.idproducto, p.codigo, p.nombre, p.descripcion, p.color, "
                    + "p.categoria_id, p.precio, p.MT, p.stock, p.ubicacion, "
                    + "p.proveedor_id, p.acabado, p.trafico, p.rectificado, p.imagen, "
                    + "p.fecha_creacion, p.fecha_actualizacion, "
                    + "c.nombre as categoria_nombre, pr.nombre as proveedor_nombre "
                    + "FROM productos p "
                    + "LEFT JOIN categorias c ON p.categoria_id = c.idcategoria " 
                    + "LEFT JOIN proveedores pr ON p.proveedor_id = pr.idproveedor " 
                    + "WHERE p.idproducto = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(idProducto));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Producto producto = new Producto();

                producto.setId(rs.getInt("idproducto")); 
                producto.setCodigo(rs.getString("codigo"));
                producto.setNombre(rs.getString("nombre"));
                producto.setDescripcion(rs.getString("descripcion"));
                producto.setColor(rs.getString("color"));
                producto.setCategoriaId(rs.getInt("categoria_id"));
                producto.setPrecio(rs.getBigDecimal("precio"));
                producto.setStock(rs.getInt("stock"));
                producto.setUbicacion(rs.getString("ubicacion"));
                producto.setProveedorId(rs.getInt("proveedor_id"));
                producto.setAcabado(rs.getString("acabado"));
                producto.setTrafico(rs.getString("trafico"));

                String rectificadoStr = rs.getString("rectificado");
                producto.setRectificado("1".equals(rectificadoStr) || "R".equals(rectificadoStr) || "true".equalsIgnoreCase(rectificadoStr));

                producto.setImagen(rs.getString("imagen"));

                java.sql.Date fechaCreacion = rs.getDate("fecha_creacion");
                java.sql.Timestamp fechaActualizacion = rs.getTimestamp("fecha_actualizacion");

                if (fechaCreacion != null) {
                    producto.setFechaCreacion(fechaCreacion.toLocalDate().atStartOfDay());
                }
                if (fechaActualizacion != null) {
                    producto.setFechaActualizacion(fechaActualizacion.toLocalDateTime());
                }

                producto.setCategoriaNombre(rs.getString("categoria_nombre"));
                producto.setProveedorNombre(rs.getString("proveedor_nombre"));

                request.setAttribute("producto", producto);
                request.getRequestDispatcher("/productoDetalle.jsp").forward(request, response);
            } else {
                response.sendRedirect("productos?error=Producto no encontrado");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("productos?error=Error al cargar el producto: " + e.getMessage());
        } finally {
            BasedeDatos.cerrarRecursos(conn, pstmt, rs);
        }
    }
}