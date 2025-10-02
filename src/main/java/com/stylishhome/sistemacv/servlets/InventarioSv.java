package com.stylishhome.sistemacv.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import portalempleadosmodelo.Categoria;
import portalempleadosmodelo.Producto;
import sistemacv.dao.ProductoDAO;

@WebServlet("/inventario")
public class InventarioSv extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");

        try {
            ProductoDAO productoDAO = new ProductoDAO(connection);

            if (action == null) {
                List<Producto> productos = productoDAO.obtenerTodosProductos();
                List<Categoria> categorias = productoDAO.obtenerCategorias();

                request.setAttribute("productos", productos);
                request.setAttribute("categorias", categorias);
                request.getRequestDispatcher("/inventario/inventario.jsp").forward(request, response);

            } else if ("nuevo".equals(action)) {
                List<Categoria> categorias = productoDAO.obtenerCategorias();
                request.setAttribute("categorias", categorias);
                request.getRequestDispatcher("/inventario/productoFormulario.jsp").forward(request, response);

            } else if ("editar".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Producto producto = productoDAO.obtenerProductoPorId(id);
                List<Categoria> categorias = productoDAO.obtenerCategorias();

                if (producto != null) {
                    request.setAttribute("producto", producto);
                    request.setAttribute("categorias", categorias);
                    request.getRequestDispatcher("/inventario/productoFormulario.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/inventario?error=Producto no encontrado");
                }

            } else if ("ver".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Producto producto = productoDAO.obtenerProductoPorId(id);

                if (producto != null) {
                    request.setAttribute("producto", producto);
                    request.getRequestDispatcher("/inventario/productoDetalle.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/inventario?error=Producto no encontrado");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/inventario?error=Error en la base de datos");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");

        try {
            ProductoDAO productoDAO = new ProductoDAO(connection);

            if ("guardar".equals(action)) {
                Producto producto = new Producto();
                producto.setCodigo(request.getParameter("codigo"));
                producto.setNombre(request.getParameter("nombre"));
                producto.setDescripcion(request.getParameter("descripcion"));
                producto.setColor(request.getParameter("color"));
                producto.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
                producto.setPrecio(new BigDecimal(request.getParameter("precio")));
                producto.setStock(Integer.parseInt(request.getParameter("stock")));
                producto.setStockMinimo(Integer.parseInt(request.getParameter("stockMinimo")));
                producto.setUbicacion(request.getParameter("ubicacion"));
                producto.setProveedorId(Integer.parseInt(request.getParameter("proveedorId")));
                producto.setAcabado(request.getParameter("acabado"));
                producto.setTrafico(request.getParameter("trafico"));
                producto.setRectificado(request.getParameter("rectificado") != null);
                producto.setImagen(request.getParameter("imagen"));

                boolean exito = productoDAO.crearProducto(producto);
                if (exito) {
                    response.sendRedirect(request.getContextPath() + "/inventario?success=Producto creado exitosamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/inventario?error=Error al crear producto");
                }

            } else if ("actualizar".equals(action)) {
                Producto producto = new Producto();
                producto.setId(Integer.parseInt(request.getParameter("id")));
                producto.setCodigo(request.getParameter("codigo"));
                producto.setNombre(request.getParameter("nombre"));
                producto.setDescripcion(request.getParameter("descripcion"));
                producto.setColor(request.getParameter("color"));
                producto.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
                producto.setPrecio(new BigDecimal(request.getParameter("precio")));
                producto.setStock(Integer.parseInt(request.getParameter("stock")));
                producto.setStockMinimo(Integer.parseInt(request.getParameter("stockMinimo")));
                producto.setUbicacion(request.getParameter("ubicacion"));
                producto.setProveedorId(Integer.parseInt(request.getParameter("proveedorId")));
                producto.setAcabado(request.getParameter("acabado"));
                producto.setTrafico(request.getParameter("trafico"));
                producto.setRectificado(request.getParameter("rectificado") != null);
                producto.setImagen(request.getParameter("imagen"));

                boolean exito = productoDAO.actualizarProducto(producto);
                if (exito) {
                    response.sendRedirect(request.getContextPath() + "/inventario?success=Producto actualizado exitosamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/inventario?error=Error al actualizar producto");
                }

            } else if ("eliminar".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean exito = productoDAO.eliminarProducto(id);

                if (exito) {
                    response.sendRedirect(request.getContextPath() + "/inventario?success=Producto eliminado exitosamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/inventario?error=Error al eliminar producto");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/inventario?error=Error en la base de datos");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/inventario?error=Error en el formato de los datos");
        }
    }
}
