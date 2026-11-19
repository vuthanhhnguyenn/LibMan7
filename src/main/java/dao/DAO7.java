package dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Lớp cha của mọi lớp DAO: mở kết nối CSDL và giữ trong thuộc tính con
 * để các lớp con dùng chung. Thông tin kết nối đọc từ db.properties.
 * Mỗi đối tượng DAO có kết nối riêng, trang JSP gọi close() khi dùng xong,
 * nên hai yêu cầu chạy song song không dùng chung một giao dịch.
 */
public abstract class DAO7 {
    protected Connection con;

    public DAO7() {
        Properties p = new Properties();
        try (InputStream in = DAO7.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                p.load(in);
            }
            String url = System.getProperty("db.url", p.getProperty("db.url", "jdbc:postgresql://localhost:5432/libman7"));
            String user = System.getProperty("db.user", p.getProperty("db.user", "postgres"));
            String pass = System.getProperty("db.password", p.getProperty("db.password", "postgres"));
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            throw new IllegalStateException("Không kết nối được CSDL", e);
        }
    }

    /** Đóng kết nối. Gọi trong khối finally của trang JSP. */
    public void close() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            // bỏ qua: kết nối đã hỏng thì cũng không dùng lại
        }
    }

    /** Chuyển java.util.Date sang java.sql.Date để truyền vào câu lệnh SQL. */
    protected static java.sql.Date toSql(java.util.Date d) {
        return d == null ? null : new java.sql.Date(d.getTime());
    }
}
