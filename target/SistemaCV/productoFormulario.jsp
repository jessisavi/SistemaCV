<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="portalempleadosmodelo.Producto" %>
<%@ page import="portalempleadosmodelo.Categoria" %>
<%@ page import="java.util.List" %>
<%
    Producto producto = (Producto) request.getAttribute("producto");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    boolean isEdit = producto != null;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= isEdit ? "Editar" : "Nuevo" %> Producto | Sistema</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/StylePF.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card card-custom mt-4">
                        <div class="card-header card-header-custom">
                            <h4 class="mb-0">
                                <i class="fas <%= isEdit ? "fa-edit" : "fa-plus" %> me-2"></i>
                                <%= isEdit ? "Editar Producto" : "Nuevo Producto" %>
                            </h4>
                            <a href="${pageContext.request.contextPath}/productos" class="btn btn-outline-custom btn-sm">
                                <i class="fas fa-arrow-left me-1"></i> Volver
                            </a>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/productos" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="<%= isEdit ? "actualizar" : "guardar" %>">
                                <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= producto.getId() %>">
                                <% } %>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="nombre" class="form-label">Nombre del Producto *</label>
                                            <input type="text" class="form-control" id="nombre" name="nombre" 
                                                   value="<%= isEdit ? producto.getNombre() : "" %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="codigo" class="form-label">Código *</label>
                                            <input type="text" class="form-control" id="codigo" name="codigo" 
                                                   value="<%= isEdit ? producto.getCodigo() : "" %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="color" class="form-label">Color *</label>
                                            <input type="text" class="form-control" id="color" name="color" 
                                                   value="<%= isEdit ? producto.getColor() : "" %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="categoriaId" class="form-label">Categoría *</label>
                                            <select class="form-select" id="categoriaId" name="categoriaId" required>
                                                <option value="" disabled <%= !isEdit ? "selected" : "" %>>Seleccionar categoría</option>
                                                <% if (categorias != null) { 
                                                for (Categoria cat : categorias) { %>
                                                <option value="<%= cat.getId() %>" 
                                                        <%= isEdit && producto.getCategoriaId() == cat.getId() ? "selected" : "" %>>
                                                    <%= cat.getNombre() %>
                                                </option>
                                                <% } } %>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="acabado" class="form-label">Acabado</label>
                                            <select class="form-select" id="acabado" name="acabado">
                                                <option value="" <%= isEdit && producto.getAcabado() == null ? "selected" : "" %>>Seleccionar Acabado</option>
                                                <option value="Brillante" <%= isEdit && "Brillante".equals(producto.getAcabado()) ? "selected" : "" %>>Brillante</option>
                                                <option value="Semibrillante" <%= isEdit && "Semibrillante".equals(producto.getAcabado()) ? "selected" : "" %>>Semibrillante</option>
                                                <option value="Mate" <%= isEdit && "Mate".equals(producto.getAcabado()) ? "selected" : "" %>>Mate</option>
                                                <option value="Antideslizante" <%= isEdit && "Antideslizante".equals(producto.getAcabado()) ? "selected" : "" %>>Antideslizante</option>
                                                <option value="Rustico" <%= isEdit && "Rustico".equals(producto.getAcabado()) ? "selected" : "" %>>Rustico</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="descripcion" class="form-label">Descripción</label>
                                            <textarea class="form-control" id="descripcion" name="descripcion" rows="3"><%= isEdit ? producto.getDescripcion() : "" %></textarea>
                                        </div>
                                        <div class="mb-3 form-check">
                                            <input type="checkbox" class="form-check-input" id="rectificado" name="rectificado" 
                                                   <%= isEdit && producto.isRectificado() ? "checked" : "" %>>
                                            <label class="form-check-label" for="rectificado">Rectificado</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="precio" class="form-label">Precio Unitario *</label>
                                            <input type="number" step="0.01" class="form-control" id="precio" name="precio" 
                                                   value="<%= isEdit ? producto.getPrecio() : "" %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="mt" class="form-label">MT</label>
                                            <input type="text" class="form-control" id="mt" name="mt" 
                                                   value="<%= isEdit ? producto.getMt() : "" %>">
                                        </div>
                                        <div class="mb-3">
                                            <label for="stock" class="form-label">Stock Inicial *</label>
                                            <input type="number" class="form-control" id="stock" name="stock" 
                                                   value="<%= isEdit ? producto.getStock() : "" %>" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="ubicacion" class="form-label">Ubicación en Almacén</label>
                                            <input type="text" class="form-control" id="ubicacion" name="ubicacion" 
                                                   value="<%= isEdit ? producto.getUbicacion() : "" %>">
                                        </div>
                                        <div class="mb-3">
                                            <label for="trafico" class="form-label">Tráfico</label>
                                            <select class="form-select" id="trafico" name="trafico">
                                                <option value="" <%= isEdit && producto.getTrafico() == null ? "selected" : "" %>>Seleccionar Tráfico</option>
                                                <option value="Comercial Alto" <%= isEdit && "Comercial Alto".equals(producto.getTrafico()) ? "selected" : "" %>>Comercial Alto</option>
                                                <option value="Comercial Bajo" <%= isEdit && "Comercial Bajo".equals(producto.getTrafico()) ? "selected" : "" %>>Comercial Bajo</option>
                                                <option value="Comercial Medio" <%= isEdit && "Comercial Medio".equals(producto.getTrafico()) ? "selected" : "" %>>Comercial Medio</option>
                                                <option value="Residencial Alto" <%= isEdit && "Residencial Alto".equals(producto.getTrafico()) ? "selected" : "" %>>Residencial Alto</option>
                                                <option value="Residencial Medio" <%= isEdit && "Residencial Medio".equals(producto.getTrafico()) ? "selected" : "" %>>Residencial Medio</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="proveedorId" class="form-label">Proveedor *</label>
                                            <select class="form-select" id="proveedorId" name="proveedorId" required>
                                                <option value="" disabled <%= !isEdit ? "selected" : "" %>>Seleccionar proveedor</option>
                                                <option value="1" <%= isEdit && producto.getProveedorId() == 1 ? "selected" : "" %>>Rocersa</option>
                                                <option value="2" <%= isEdit && producto.getProveedorId() == 2 ? "selected" : "" %>>Porcelanatos Premium</option>
                                                <option value="3" <%= isEdit && producto.getProveedorId() == 3 ? "selected" : "" %>>Lavabos Elegance</option>
                                                <option value="4" <%= isEdit && producto.getProveedorId() == 4 ? "selected" : "" %>>Muebles Cocina Plus</option>
                                                <option value="5" <%= isEdit && producto.getProveedorId() == 5 ? "selected" : "" %>>Portobello</option>
                                                <option value="6" <%= isEdit && producto.getProveedorId() == 6 ? "selected" : "" %>>Siho</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="imagen" class="form-label">Imagen del Producto</label>
                                    <input class="form-control" type="file" id="imagen" name="imagen" accept="image/*">
                                    <% if (isEdit && producto.getImagen() != null) { %>
                                    <small class="text-muted">Imagen actual: <%= producto.getImagen() %></small>
                                    <% } %>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${pageContext.request.contextPath}/productos" class="btn btn-secondary">Cancelar</a>
                                    <button type="submit" class="btn btn-custom">
                                        <i class="fas fa-save me-1"></i>
                                        <%= isEdit ? "Actualizar" : "Guardar" %> Producto
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>