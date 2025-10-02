package portalempleadosmodelo;

import java.util.List;

public class Rol {
    private int id;
    private String nombre;
    private String descripcion;
    private int numeroUsuarios;
    private List<String> permisos;
    
    public Rol(){}
    
    public Rol (int id, String nombre, String descripcion, int numeroUsuarios) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.numeroUsuarios = numeroUsuarios;
    }
    
    public int getId () {return id; }
    public void setId (int id) {this.id = id; }
    
    public String getNombre () {return nombre;}
    public void setNombre (String nombre) {this.nombre = nombre; }
    
    public String getDescripcion () {return descripcion; }
    public void setDescripcion (String descripcion) {this.descripcion =descripcion; }
    
    public int getNumeroUsuarios() { return numeroUsuarios; }
    public void setNumeroUsuarios(int numeroUsuarios) { this.numeroUsuarios = numeroUsuarios; }
    
    public List<String> getPermisos () {return permisos; }
    public void setPermisos (List<String> permisos) {this.permisos = permisos; }
}