package sistemacv.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import portalempleadosmodelo.Rol;

public class RolDAO {

    private Connection conexion;

    public RolDAO(Connection conexion) {
        this.conexion = conexion;
    }

    public List<Rol> obtenerTodosLosRoles() throws SQLException {
        List<Rol> roles = new ArrayList<>();
        String sql = "SELECT id, nombre, descripcion, numero_usuarios FROM roles"; 

        try (PreparedStatement stmt = conexion.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rol rol = new Rol(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("descripcion"),
                        rs.getInt("numero_usuarios") 
                );
                roles.add(rol);
            }
        }
        return roles;
    }

    public boolean crearRol(Rol rol) throws SQLException {
        String sql = "INSERT INTO roles (nombre, descripcion, numero_usuarios) VALUES (?, ?, ?)"; 

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, rol.getNombre());
            stmt.setString(2, rol.getDescripcion());
            stmt.setInt(3, rol.getNumeroUsuarios());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean actualizarRol(Rol rol) throws SQLException {
        String sql = "UPDATE roles SET nombre = ?, descripcion = ?, numero_usuarios = ? WHERE id = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setString(1, rol.getNombre());
            stmt.setString(2, rol.getDescripcion());
            stmt.setInt(3, rol.getNumeroUsuarios());
            stmt.setInt(4, rol.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean eliminarRol(int id) throws SQLException {
        String sql = "DELETE FROM roles WHERE id = ?";

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);

            return stmt.executeUpdate() > 0;
        }
    }

    public Rol obtenerRolPorId(int id) throws SQLException {
        String sql = "SELECT id, nombre, descripcion, numero_usuarios FROM roles WHERE id = ?"; 

        try (PreparedStatement stmt = conexion.prepareStatement(sql)) {
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Rol(
                            rs.getInt("id"),
                            rs.getString("nombre"),
                            rs.getString("descripcion"),
                            rs.getInt("numero_usuarios")
                    );
                }
            }
        }
        return null;
    }
}