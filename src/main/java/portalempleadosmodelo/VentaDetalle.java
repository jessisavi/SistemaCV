package portalempleadosmodelo;

import java.math.BigDecimal;

public class VentaDetalle {
    private int id;
    private int idventa;
    private int idproducto;
    private Producto producto;
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal total;
    
    public VentaDetalle() {}
    
    public VentaDetalle(int id, int idventa, int idproducto, int cantidad, 
                       BigDecimal precioUnitario, BigDecimal total) {
        this.id = id;
        this.idventa = idventa;
        this.idproducto = idproducto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.total = total;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getIdventa() { return idventa; }
    public void setIdventa(int idventa) { this.idventa = idventa; }
    
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
    
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    public BigDecimal getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(BigDecimal precioUnitario) { this.precioUnitario = precioUnitario; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    // Método para calcular total
    public void calcularTotal() {
        if (precioUnitario != null && cantidad > 0) {
            this.total = precioUnitario.multiply(BigDecimal.valueOf(cantidad));
        } else {
            this.total = BigDecimal.ZERO;
        }
    }
}