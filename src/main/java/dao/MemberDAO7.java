package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import model.Librarian7;
import model.Manager7;
import model.Member7;
import model.Reader7;
import model.Staff7;

/** Xử lý đăng nhập dùng chung cho mọi thành viên. */
public class MemberDAO7 extends DAO7 {

    public MemberDAO7() {
        super();
    }

    /**
     * Kiểm tra tên đăng nhập và mật khẩu.
     * Trả về Reader7, Manager7 hoặc Librarian7 tùy vai trò; sai thông tin thì trả về null.
     */
    public Member7 checkLogin(String username, String password) {
        if (username == null || password == null || username.isBlank() || password.isEmpty()) {
            return null;
        }
        String sql = "SELECT m.id, m.username, m.password, m.fullName, m.role, s.staffCode, s.position, r.readerCode "
                + "FROM tblMember7 m "
                + "LEFT JOIN tblStaff7 s ON s.tblMember7id = m.id "
                + "LEFT JOIN tblReader7 r ON r.tblMember7id = m.id "
                + "WHERE m.username = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || !verifyPassword(password, rs.getString("password"))) {
                    return null;
                }
                Member7 m;
                if ("reader".equals(rs.getString("role"))) {
                    Reader7 r = new Reader7();
                    r.setReaderCode(rs.getString("readerCode"));
                    m = r;
                } else {
                    Staff7 s = "Nhân viên quản lý".equals(rs.getString("position")) ? new Manager7() : new Librarian7();
                    s.setStaffCode(rs.getString("staffCode"));
                    s.setPosition(rs.getString("position"));
                    m = s;
                }
                m.setId(rs.getInt("id"));
                m.setUsername(rs.getString("username"));
                m.setFullName(rs.getString("fullName"));
                m.setRole(rs.getString("role"));
                return m;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
    }

    /** Mật khẩu lưu dạng pbkdf2$soVong$muoi$bam (PBKDF2-HmacSHA256, muối riêng cho từng tài khoản). */
    private static boolean verifyPassword(String password, String stored) {
        try {
            String[] p = stored.split("\\$");
            if (p.length != 4 || !"pbkdf2".equals(p[0])) {
                return false;
            }
            int rounds = Integer.parseInt(p[1]);
            byte[] salt = Base64.getDecoder().decode(p[2]);
            byte[] expected = Base64.getDecoder().decode(p[3]);
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, rounds, expected.length * 8);
            byte[] actual = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return MessageDigest.isEqual(expected, actual);
        } catch (Exception e) {
            return false;
        }
    }
}
