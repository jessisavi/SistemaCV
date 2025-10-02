package portalempleado.utilidades;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BasedeDatos {

    private static final Logger logger = Logger.getLogger(BasedeDatos.class.getName());

    private static final String URL = "jdbc:mysql://localhost:3306/servletsistemacv";
    private static final String usuario = "root";
    private static final String contraseña = "";

    private static final int MAX_RETRY_ATTEMPTS = 3;
    private static final int RETRY_DELAY_MS = 1000;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("Driver MySQL registrado exitosamente");
        } catch (ClassNotFoundException e) {
            logger.severe("Error al registrar el driver MySQL: " + e.getMessage());
            throw new ExceptionInInitializerError("Driver MySQL no encontrado");
        }
    }

    public static Connection getConnection() throws SQLException {
        SQLException lastException = null;

        for (int attempt = 1; attempt <= MAX_RETRY_ATTEMPTS; attempt++) {
            try {
                Connection connection = DriverManager.getConnection(URL, usuario, contraseña);

                if (connection.isValid(5)) {
                    logger.info("Conexión a BD establecida exitosamente (Intento " + attempt + ")");
                    return connection;
                } else {
                    connection.close();
                    throw new SQLException("Conexión no válida");
                }

            } catch (SQLException e) {
                lastException = e;
                logger.warning("Intento " + attempt + " fallido: " + e.getMessage());

                if (attempt < MAX_RETRY_ATTEMPTS) {
                    try {
                        Thread.sleep(RETRY_DELAY_MS);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new SQLException("Interrupción durante el reintento de conexión", ie);
                    }
                }
            }
        }

        logger.severe("No se pudo establecer conexión después de " + MAX_RETRY_ATTEMPTS + " intentos");
        throw new SQLException("No se pudo establecer conexión con la base de datos después de "
                + MAX_RETRY_ATTEMPTS + " intentos", lastException);
    }

    public static boolean probarConexion() {
        Connection connection = null;
        try {
            connection = getConnection();
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            logger.severe("Error al probar conexión: " + e.getMessage());
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    logger.warning("Error al cerrar conexión de prueba: " + e.getMessage());
                }
            }
        }
    }

    public static void main(String[] args) {
        System.out.println("=== Probando conexión a la base de datos ===");

        if (probarConexion()) {
            System.out.println("✅ Conexión exitosa a la base de datos");

            Connection conexion = null;
            Statement statement = null;
            ResultSet rs = null;

            try {
                conexion = getConnection();
                statement = conexion.createStatement();
                rs = statement.executeQuery("SELECT COUNT(*) as total FROM portalempleados");

                if (rs.next()) {
                    System.out.println("✅ Total de empleados en la base de datos: " + rs.getInt("total"));
                }

            } catch (SQLException ex) {
                logger.log(Level.SEVERE, "Error en consulta de prueba", ex);
                System.out.println("❌ Error en consulta: " + ex.getMessage());
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (statement != null) {
                        statement.close();
                    }
                    if (conexion != null) {
                        conexion.close();
                    }
                } catch (SQLException ex) {
                    logger.log(Level.WARNING, "Error al cerrar recursos", ex);
                }
            }
        } else {
            System.out.println("❌ No se pudo conectar a la base de datos");
            System.out.println("Verifique que:");
            System.out.println("1. MySQL esté ejecutándose");
            System.out.println("2. La base de datos 'servletsistemacv' exista");
            System.out.println("3. Las credenciales sean correctas");
            System.out.println("4. El driver MySQL esté en el classpath");
        }
    }

    public static void cerrarRecursos(AutoCloseable... recursos) {
        for (AutoCloseable recurso : recursos) {
            if (recurso != null) {
                try {
                    recurso.close();
                } catch (Exception e) {
                    logger.warning("Error al cerrar recurso: " + e.getMessage());
                }
            }
        }
    }

    public static void rollbackSeguro(Connection connection) {
        if (connection != null) {
            try {
                connection.rollback();
            } catch (SQLException e) {
                logger.warning("Error al realizar rollback: " + e.getMessage());
            }
        }
    }
}
