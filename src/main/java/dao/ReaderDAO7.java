package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Reader7;

public class ReaderDAO7 extends DAO7 {

    public ReaderDAO7() {
        super();
    }

    /** Lấy thông tin bạn đọc theo id (bảng tblMember7 nối tblReader7). Không có thì trả về null. */
    public Reader7 getReader(int id) {
        String sql = "SELECT m.id, m.username, m.fullName, m.dateOfBirth, m.address, m.email, m.phone, m.role, "
                + "r.readerCode, r.classOrUnit "
                + "FROM tblMember7 m JOIN tblReader7 r ON r.tblMember7id = m.id "
                + "WHERE m.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Reader7 r = new Reader7();
                r.setId(rs.getInt("id"));
                r.setUsername(rs.getString("username"));
                r.setFullName(rs.getString("fullName"));
                r.setDateOfBirth(rs.getDate("dateOfBirth"));
                r.setAddress(rs.getString("address"));
                r.setEmail(rs.getString("email"));
                r.setPhone(rs.getString("phone"));
                r.setRole(rs.getString("role"));
                r.setReaderCode(rs.getString("readerCode"));
                r.setClassOrUnit(rs.getString("classOrUnit"));
                return r;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
    }
}
