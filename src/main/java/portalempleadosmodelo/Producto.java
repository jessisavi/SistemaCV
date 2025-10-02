package portalempleadosmodelo;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Producto {

    private int id;
    private String codigo;
    private String nombre;
    private String descripcion;
    private String color;
    private int categoriaId;
    private String categoriaNombre;
    private BigDecimal precio;
    private int stock;
    private int stockMinimo;
    private String ubicacion;
    private int proveedorId;
    private String proveedorNombre;
    private String acabado;
    private String trafico;
    private boolean rectificado;
    private String imagen;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;

    public Producto() {
    }

    public Producto(int id, String codigo, String nombre, String descripcion, String color,
            int categoriaId, BigDecimal precio, int stock, int stockMinimo,
            String ubicacion, int proveedorId, String acabado, String trafico,
            boolean rectificado, String imagen) {
        this.id = id;
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.color = color;
        this.categoriaId = categoriaId;
        this.precio = precio;
        this.stock = stock;
        this.stockMinimo = stockMinimo;
        this.ubicacion = ubicacion;
        this.proveedorId = proveedorId;
        this.acabado = acabado;
        this.trafico = trafico;
        this.rectificado = rectificado;
        this.imagen = imagen;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(int categoriaId) {
        this.categoriaId = categoriaId;
    }

    public String getCategoriaNombre() {
        return categoriaNombre;
    }

    public void setCategoriaNombre(String categoriaNombre) {
        this.categoriaNombre = categoriaNombre;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getStockMinimo() {
        return stockMinimo;
    }

    public void setStockMinimo(int stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }

    public int getProveedorId() {
        return proveedorId;
    }

    public void setProveedorId(int proveedorId) {
        this.proveedorId = proveedorId;
    }

    public String getProveedorNombre() {
        return proveedorNombre;
    }

    public void setProveedorNombre(String proveedorNombre) {
        this.proveedorNombre = proveedorNombre;
    }

    public String getAcabado() {
        return acabado;
    }

    public void setAcabado(String acabado) {
        this.acabado = acabado;
    }

    public String getTrafico() {
        return trafico;
    }

    public void setTrafico(String trafico) {
        this.trafico = trafico;
    }

    public boolean isRectificado() {
        return rectificado;
    }

    public void setRectificado(boolean rectificado) {
        this.rectificado = rectificado;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(LocalDateTime fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }
}
