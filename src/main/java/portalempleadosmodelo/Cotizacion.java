package portalempleadosmodelo;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class Cotizacion {
    private int idcotizacion;
    private String numeroCotizacion;
    private int idcliente; 
    private Cliente cliente;
    private int idempleado; 
    private LocalDate fecha;
    private LocalDate validoHasta;
    private String proyecto;
    private String notas;
    private String terminos;
    private BigDecimal subtotal;
    private BigDecimal descuento;
    private BigDecimal iva;
    private BigDecimal total;
    private String estado;
    private LocalDateTime fechaCreacion;
    private List<CotizacionDetalle> detalles;

    public Cotizacion() {}
    
    public Cotizacion(int idcotizacion, String numeroCotizacion, int idcliente, LocalDate fecha, 
                     LocalDate validoHasta, String estado, BigDecimal total) {
        this.idcotizacion = idcotizacion;
        this.numeroCotizacion = numeroCotizacion;
        this.idcliente = idcliente;
        this.fecha = fecha;
        this.validoHasta = validoHasta;
        this.estado = estado;
        this.total = total;
    }
    

    public int getIdcotizacion() { return idcotizacion; }
    public void setIdcotizacion(int idcotizacion) { this.idcotizacion = idcotizacion; }
    
    public String getNumeroCotizacion() { return numeroCotizacion; }
    public void setNumeroCotizacion(String numeroCotizacion) { this.numeroCotizacion = numeroCotizacion; }
    
    public int getIdcliente() { return idcliente; }
    public void setIdcliente(int idcliente) { this.idcliente = idcliente; }
    
    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
    
    public int getIdempleado() { return idempleado; }
    public void setIdempleado(int idempleado) { this.idempleado = idempleado; }
    
    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }
    
    public LocalDate getValidoHasta() { return validoHasta; }
    public void setValidoHasta(LocalDate validoHasta) { this.validoHasta = validoHasta; }
    
    public String getProyecto() { return proyecto; }
    public void setProyecto(String proyecto) { this.proyecto = proyecto; }
    
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
    
    public String getTerminos() { return terminos; }
    public void setTerminos(String terminos) { this.terminos = terminos; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public BigDecimal getDescuento() { return descuento; }
    public void setDescuento(BigDecimal descuento) { this.descuento = descuento; }
    
    public BigDecimal getIva() { return iva; }
    public void setIva(BigDecimal iva) { this.iva = iva; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public LocalDateTime getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(LocalDateTime fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    
    public List<CotizacionDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<CotizacionDetalle> detalles) { this.detalles = detalles; }
    
    public int getId() { return idcotizacion; }
    public void setId(int id) { this.idcotizacion = id; }
    
    public int getClienteId() { return idcliente; }
    public void setClienteId(int clienteId) { this.idcliente = clienteId; }
    
    public int getUsuarioId() { return idempleado; }
    public void setUsuarioId(int usuarioId) { this.idempleado = usuarioId; }
}