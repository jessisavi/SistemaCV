package portalempleadosmodelo;

import java.math.BigDecimal;

public class CotizacionDetalle {
    private int id;
    private int idcotizacion;
    private int idproducto; 
    private Producto producto;
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal descuentoPorcentaje;
    private BigDecimal descuentoMonto;
    private BigDecimal total;
    
    public CotizacionDetalle() {}
    
    public CotizacionDetalle(int id, int idcotizacion, int idproducto, int cantidad, 
                           BigDecimal precioUnitario, BigDecimal total) {
        this.id = id;
        this.idcotizacion = idcotizacion;
        this.idproducto = idproducto;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.total = total;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getIdcotizacion() { return idcotizacion; }
    public void setIdcotizacion(int idcotizacion) { this.idcotizacion = idcotizacion; }
    
    public int getIdproducto() { return idproducto; }
    public void setIdproducto(int idproducto) { this.idproducto = idproducto; }
    
    public Producto getProducto() { return producto; }
    public void setProducto(Producto producto) { this.producto = producto; }
    
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    public BigDecimal getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(BigDecimal precioUnitario) { this.precioUnitario = precioUnitario; }
    
    public BigDecimal getDescuentoPorcentaje() { return descuentoPorcentaje; }
    public void setDescuentoPorcentaje(BigDecimal descuentoPorcentaje) { 
        this.descuentoPorcentaje = descuentoPorcentaje; 
    }
    
    public BigDecimal getDescuentoMonto() { return descuentoMonto; }
    public void setDescuentoMonto(BigDecimal descuentoMonto) { 
        this.descuentoMonto = descuentoMonto; 
    }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    

    public int getCotizacionId() { return idcotizacion; }
    public void setCotizacionId(int cotizacionId) { this.idcotizacion = cotizacionId; }
    
    public int getProductoId() { return idproducto; }
    public void setProductoId(int productoId) { this.idproducto = productoId; }
    
    public void calcularTotal() {
        if (precioUnitario == null || cantidad <= 0) {
            this.total = BigDecimal.ZERO;
            return;
        }
        
        BigDecimal cantidadBD = BigDecimal.valueOf(cantidad);
        BigDecimal subtotal = precioUnitario.multiply(cantidadBD);
        
        if (descuentoMonto != null && descuentoMonto.compareTo(BigDecimal.ZERO) > 0) {
            this.total = subtotal.subtract(descuentoMonto);
        } else if (descuentoPorcentaje != null && descuentoPorcentaje.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal descuento = subtotal.multiply(descuentoPorcentaje).divide(BigDecimal.valueOf(100));
            this.total = subtotal.subtract(descuento);
        } else {
            this.total = subtotal;
        }
        
        if (this.total.compareTo(BigDecimal.ZERO) < 0) {
            this.total = BigDecimal.ZERO;
        }
    }
}