package portalempleadosmodelo;

public class Usuario {

    private int idempleado;
    private String usuario;
    private String contraseña;
    private String rol;

    public Usuario() {
    }

    public Usuario(int idempleado, String usuario, String contraseña, String rol) {
        this.idempleado = idempleado;
        this.usuario = usuario;
        this.contraseña = contraseña;
        this.rol = rol;
    }

    public int getIdempleado() {
        return idempleado;
    }

    public void setIdempleado(int idempleado) {
        this.idempleado = idempleado;
    }

    public String getUsuario() {
        return usuario != null ? usuario : "";
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getContraseña() {
        return contraseña != null ? contraseña : "";
    }

    public void setContraseña(String contraseña) {
        this.contraseña = contraseña;
    }

    public String getRol() {
        return rol != null ? rol : "empleado";
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    @Override
    public String toString() {
        return "Usuario{"
                + "idempleado=" + idempleado
                + ", usuario='" + usuario + '\''
                + ", rol='" + rol + '\''
                + '}';
    }

    public boolean tieneRol(String rolRequerido) {
        return rol != null && rol.equalsIgnoreCase(rolRequerido);
    }

    public boolean esValido() {
        return usuario != null && !usuario.trim().isEmpty()
                && contraseña != null && !contraseña.trim().isEmpty();
    }
}
