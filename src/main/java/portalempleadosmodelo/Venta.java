package portalempleadosmodelo;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class Venta {
    private int idventa;
    private String numeroFactura;
    private int idcliente;
    private Cliente cliente;
    private int idempleado;
    private LocalDate fecha;
    private String metodoPago;
    private String estado;
    private BigDecimal subtotal;
    private BigDecimal descuento;
    private BigDecimal iva;
    private BigDecimal total;
    private String notas;
    private LocalDateTime fechaCreacion;
    private List<VentaDetalle> detalles;
    
    public Venta() {}
    
    public Venta(int idventa, String numeroFactura, int idcliente, LocalDate fecha, 
                BigDecimal total, String estado) {
        this.idventa = idventa;
        this.numeroFactura = numeroFactura;
        this.idcliente = idcliente;
        this.fecha = fecha;
        this.total = total;
        this.estado = estado;
    }
    
    public int getIdventa() { return idventa; }
    public void setIdventa(int idventa) { this.idventa = idventa; }
    
    public String getNumeroFactura() { return numeroFactura; }
    public void setNumeroFactura(String numeroFactura) { this.numeroFactura = numeroFactura; }
    
    public int getIdcliente() { return idcliente; }
    public void setIdcliente(int idcliente) { this.idcliente = idcliente; }
    
    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
    
    public int getIdempleado() { return idempleado; }
    public void setIdempleado(int idempleado) { this.idempleado = idempleado; }
    
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
    
    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public BigDecimal getDescuento() { return descuento; }
    public void setDescuento(BigDecimal descuento) { this.descuento = descuento; }
    
    public BigDecimal getIva() { return iva; }
    public void setIva(BigDecimal iva) { this.iva = iva; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
    
    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    
    public List<VentaDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<VentaDetalle> detalles) { this.detalles = detalles; }
}