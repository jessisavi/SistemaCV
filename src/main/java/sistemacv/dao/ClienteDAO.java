package sistemacv.dao;

import portalempleado.utilidades.BasedeDatos;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import portalempleadosmodelo.Cliente;

public class ClienteDAO {

    private static final Logger logger = Logger.getLogger(ClienteDAO.class.getName());

    public List<Cliente> obtenerTodosLosClientes() {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT idcliente, idempleado, fecha_registro, nombre, apellido, "
                + "tipo_documento, numero_documento, direccion, ciudad, celular, "
                + "correo_electronico, tipo_cliente "
                + "FROM clientes ORDER BY nombre, apellido";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cliente cliente = mapearCliente(rs);
                clientes.add(cliente);
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener clientes", e);
        }

        return clientes;
    }

    public Cliente obtenerClientePorId(int id) {
        String sql = "SELECT idcliente, idempleado, fecha_registro, nombre, apellido, "
                + "tipo_documento, numero_documento, direccion, ciudad, celular, "
                + "correo_electronico, tipo_cliente "
                + "FROM clientes WHERE idcliente = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearCliente(rs);
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al obtener cliente por ID: " + id, e);
        }

        return null;
    }

    public boolean crearCliente(Cliente cliente) {
        String sql = "INSERT INTO clientes (idempleado, fecha_registro, nombre, apellido, "
                + "tipo_documento, numero_documento, direccion, ciudad, celular, "
                + "correo_electronico, tipo_cliente) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setObject(1, cliente.getIdempleado(), Types.INTEGER);
            stmt.setDate(2, cliente.getFechaRegistro() != null
                    ? Date.valueOf(cliente.getFechaRegistro()) : Date.valueOf(java.time.LocalDate.now()));
            stmt.setString(3, cliente.getNombre());
            stmt.setString(4, cliente.getApellido());
            stmt.setString(5, cliente.getTipoDocumento());
            stmt.setString(6, cliente.getNumeroDocumento());
            stmt.setString(7, cliente.getDireccion());
            stmt.setString(8, cliente.getCiudad());
            stmt.setString(9, cliente.getCelular());
            stmt.setString(10, cliente.getCorreoElectronico());
            stmt.setString(11, cliente.getTipoCliente());

            int filasAfectadas = stmt.executeUpdate();

            if (filasAfectadas > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        cliente.setIdcliente(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al crear cliente", e);
        }

        return false;
    }

    public boolean actualizarCliente(Cliente cliente) {
        String sql = "UPDATE clientes SET idempleado = ?, fecha_registro = ?, nombre = ?, "
                + "apellido = ?, tipo_documento = ?, numero_documento = ?, direccion = ?, "
                + "ciudad = ?, celular = ?, correo_electronico = ?, tipo_cliente = ? "
                + "WHERE idcliente = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, cliente.getIdempleado(), Types.INTEGER);
            stmt.setDate(2, cliente.getFechaRegistro() != null
                    ? Date.valueOf(cliente.getFechaRegistro()) : Date.valueOf(java.time.LocalDate.now()));
            stmt.setString(3, cliente.getNombre());
            stmt.setString(4, cliente.getApellido());
            stmt.setString(5, cliente.getTipoDocumento());
            stmt.setString(6, cliente.getNumeroDocumento());
            stmt.setString(7, cliente.getDireccion());
            stmt.setString(8, cliente.getCiudad());
            stmt.setString(9, cliente.getCelular());
            stmt.setString(10, cliente.getCorreoElectronico());
            stmt.setString(11, cliente.getTipoCliente());
            stmt.setInt(12, cliente.getIdcliente());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al actualizar cliente: " + cliente.getIdcliente(), e);
            return false;
        }
    }

    public boolean eliminarCliente(int id) {
        String sql = "DELETE FROM clientes WHERE idcliente = ?";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al eliminar cliente: " + id, e);
            return false;
        }
    }

    public List<Cliente> buscarClientesPorNombre(String criterio) {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT idcliente, idempleado, fecha_registro, nombre, apellido, "
                + "tipo_documento, numero_documento, direccion, ciudad, celular, "
                + "correo_electronico, tipo_cliente "
                + "FROM clientes WHERE nombre LIKE ? OR apellido LIKE ? "
                + "ORDER BY nombre, apellido";

        try (Connection conn = BasedeDatos.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String likeCriterio = "%" + criterio + "%";
            stmt.setString(1, likeCriterio);
            stmt.setString(2, likeCriterio);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Cliente cliente = mapearCliente(rs);
                    clientes.add(cliente);
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error al buscar clientes por nombre: " + criterio, e);
        }

        return clientes;
    }

    private Cliente mapearCliente(ResultSet rs) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setIdcliente(rs.getInt("idcliente"));
        cliente.setIdempleado(rs.getObject("idempleado") != null ? rs.getInt("idempleado") : null);

        Date fechaRegistro = rs.getDate("fecha_registro");
        if (fechaRegistro != null) {
            cliente.setFechaRegistro(fechaRegistro.toLocalDate());
        }

        cliente.setNombre(rs.getString("nombre"));
        cliente.setApellido(rs.getString("apellido"));
        cliente.setTipoDocumento(rs.getString("tipo_documento"));
        cliente.setNumeroDocumento(rs.getString("numero_documento"));
        cliente.setDireccion(rs.getString("direccion"));
        cliente.setCiudad(rs.getString("ciudad"));
        cliente.setCelular(rs.getString("celular"));
        cliente.setCorreoElectronico(rs.getString("correo_electronico"));
        cliente.setTipoCliente(rs.getString("tipo_cliente"));

        return cliente;
    }

    public List<Cliente> obtenerClientesActivos() {
        return obtenerTodosLosClientes();
    }
}
