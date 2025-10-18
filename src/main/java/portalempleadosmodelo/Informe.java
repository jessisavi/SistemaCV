package portalempleado.modelos;

import java.time.LocalDate;

public class Informe {

    private int idInforme;
    private String tipo;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String descripcion;
    private LocalDate fechaGeneracion;

    public Informe() {
    }

    public Informe(int idInforme, String tipo, LocalDate fechaInicio, LocalDate fechaFin,
            String descripcion, LocalDate fechaGeneracion) {
        this.idInforme = idInforme;
        this.tipo = tipo;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.descripcion = descripcion;
        this.fechaGeneracion = fechaGeneracion;
    }

    public int getId() {
        return idInforme;
    }

    public void setId(int idInforme) {
        this.idInforme = idInforme;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDate getFechaGeneracion() {
        return fechaGeneracion;
    }

    public void setFechaGeneracion(LocalDate fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }
}
