package sistemacv.listener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class MySQLCleanupListener implements ServletContextListener {

    private static final Logger logger = Logger.getLogger(MySQLCleanupListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("MySQL Cleanup Listener inicializado");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Limpiando recursos MySQL...");

        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            logger.info("Hilo de limpieza MySQL detenido");
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error deteniendo hilo de limpieza MySQL: " + e.getMessage());
        }

        try {
            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                if (driver.getClass().getName().contains("mysql")) {
                    DriverManager.deregisterDriver(driver);
                    logger.info("Driver MySQL desregistrado: " + driver.getClass().getName());
                }
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error desregistrando drivers MySQL: " + e.getMessage());
        }

        logger.info("Limpieza de recursos MySQL completada");
    }
}
