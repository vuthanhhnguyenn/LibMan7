package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Savepoint;

import model.Reader7;
import model.ReaderCard7;

public class ReaderCardDAO7 extends DAO7 {

    public ReaderCardDAO7() {
        super();
    }

    /**
     * Tìm thẻ chưa hết hạn của bạn đọc: hạn từ hôm nay trở đi và trạng thái
     * Còn hiệu lực hoặc Bị khóa. Không có thì trả về null.
     */
    public ReaderCard7 getActiveCard(int readerId) {
        String sql = "SELECT id, cardCode, cardType, registerDate, expiryDate, status FROM tblReaderCard7 "
                + "WHERE tblReader7id = ? AND status IN ('Còn hiệu lực', 'Bị khóa') AND expiryDate >= CURRENT_DATE "
                + "ORDER BY expiryDate DESC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                ReaderCard7 c = new ReaderCard7();
                c.setId(rs.getInt("id"));
                c.setCardCode(rs.getString("cardCode"));
                c.setCardType(rs.getString("cardType"));
                c.setRegisterDate(rs.getDate("registerDate"));
                c.setExpiryDate(rs.getDate("expiryDate"));
                c.setStatus(rs.getString("status"));
                return c;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
    }

    /**
     * Thêm thẻ mới trong một giao dịch:
     * khóa bản ghi bạn đọc, chuyển các thẻ đã qua hạn sang Hết hạn, kiểm tra lại không còn thẻ
     * chưa hết hạn, cập nhật thông tin bạn đọc, thêm thẻ với mã tự sinh và trạng thái Còn hiệu lực.
     * Bước nào lỗi thì hủy cả giao dịch và trả về false.
     * Nếu nơi gọi đã mở giao dịch (kiểm thử đơn vị) thì hàm chạy trong giao dịch đó bằng savepoint.
     */
    public boolean addCard(ReaderCard7 card) {
        if (card == null || card.getReader() == null) {
            return false;
        }
        Reader7 r = card.getReader();
        boolean ownTx = true;
        Savepoint sp = null;
        try {
            ownTx = con.getAutoCommit();
            if (ownTx) {
                con.setAutoCommit(false);
            } else {
                sp = con.setSavepoint();
            }

            // 1. Khóa bản ghi bạn đọc để hai yêu cầu cùng lúc của một bạn đọc chạy lần lượt
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT tblMember7id FROM tblReader7 WHERE tblMember7id = ? FOR UPDATE")) {
                ps.setInt(1, r.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        undo(ownTx, sp);
                        return false;
                    }
                }
            }

            // 2. Thẻ đã qua hạn mà chưa đổi trạng thái thì chuyển sang Hết hạn
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE tblReaderCard7 SET status = 'Hết hạn' "
                    + "WHERE tblReader7id = ? AND status <> 'Hết hạn' AND expiryDate < CURRENT_DATE")) {
                ps.setInt(1, r.getId());
                ps.executeUpdate();
            }

            // 3. Kiểm tra lại: còn thẻ chưa hết hạn thì không thêm
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT 1 FROM tblReaderCard7 WHERE tblReader7id = ? AND status <> 'Hết hạn'")) {
                ps.setInt(1, r.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        undo(ownTx, sp);
                        return false;
                    }
                }
            }

            // 4. Cập nhật thông tin cá nhân và thông tin bạn đọc theo form
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE tblMember7 SET fullName = ?, dateOfBirth = ?, email = ?, phone = ?, address = ? WHERE id = ?")) {
                ps.setString(1, r.getFullName());
                ps.setDate(2, toSql(r.getDateOfBirth()));
                ps.setString(3, r.getEmail());
                ps.setString(4, r.getPhone());
                ps.setString(5, r.getAddress());
                ps.setInt(6, r.getId());
                ps.executeUpdate();
            }
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE tblReader7 SET readerCode = ?, classOrUnit = ? WHERE tblMember7id = ?")) {
                ps.setString(1, r.getReaderCode());
                ps.setString(2, r.getClassOrUnit());
                ps.setInt(3, r.getId());
                ps.executeUpdate();
            }

            // 5. Thêm thẻ, mã thẻ = RC + năm đăng ký + số thứ tự 6 chữ số
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO tblReaderCard7(cardCode, cardType, registerDate, expiryDate, status, tblReader7id) "
                    + "VALUES ('RC' || to_char(?::date, 'YYYY') || lpad(nextval('seqCardCode7')::text, 6, '0'), "
                    + "?, ?, ?, 'Còn hiệu lực', ?) RETURNING id, cardCode, status")) {
                ps.setDate(1, toSql(card.getRegisterDate()));
                ps.setString(2, card.getCardType());
                ps.setDate(3, toSql(card.getRegisterDate()));
                ps.setDate(4, toSql(card.getExpiryDate()));
                ps.setInt(5, r.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();
                    card.setId(rs.getInt("id"));
                    card.setCardCode(rs.getString("cardCode"));
                    card.setStatus(rs.getString("status"));
                }
            }

            if (ownTx) {
                con.commit();
            } else {
                con.releaseSavepoint(sp);
            }
            return true;
        } catch (SQLException e) {
            // ví dụ: mã sinh viên đã thuộc bạn đọc khác, vi phạm ràng buộc, mất kết nối
            undo(ownTx, sp);
            return false;
        } finally {
            if (ownTx) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    // kết nối đã hỏng
                }
            }
        }
    }

    private void undo(boolean ownTx, Savepoint sp) {
        try {
            if (ownTx) {
                con.rollback();
            } else if (sp != null) {
                con.rollback(sp);
            }
        } catch (SQLException e) {
            // kết nối đã hỏng, giao dịch tự hủy
        }
    }
}
