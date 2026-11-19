package dao;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import model.Reader7;
import model.ReaderCard7;

/**
 * Kiểm thử ReaderCardDAO7 trên CSDL có dữ liệu mẫu (sql/02_data.sql).
 * Mỗi ca chạy trong một giao dịch và rollback ở cuối nên CSDL không đổi.
 */
class TestReaderCardDAO7 {
    // id bạn đọc trong dữ liệu mẫu
    static final int AN = 3, KHOA = 4, HA = 5, DUC = 6, MAI_LAN = 8, HUNG = 11, NOT_EXIST = 9999;

    ReaderCardDAO7 dao;

    @BeforeEach
    void setUp() throws SQLException {
        try {
            dao = new ReaderCardDAO7();
        } catch (IllegalStateException e) {
            Assumptions.abort("Chưa có CSDL libman7, bỏ qua kiểm thử");
        }
        dao.con.setAutoCommit(false);
    }

    @AfterEach
    void tearDown() throws SQLException {
        if (dao != null) {
            dao.con.rollback();
            dao.close();
        }
    }

    // ---------- getActiveCard ----------

    @Test
    @DisplayName("getActiveCard: bạn đọc có thẻ Còn hiệu lực -> trả về thẻ đó")
    void activeCardValid() {
        ReaderCard7 c = dao.getActiveCard(HA);
        assertNotNull(c);
        assertEquals("RC2026000087", c.getCardCode());
        assertEquals("Còn hiệu lực", c.getStatus());
    }

    @Test
    @DisplayName("getActiveCard: thẻ Bị khóa chưa hết hạn cũng tính là chưa hết hạn")
    void activeCardLocked() {
        ReaderCard7 c = dao.getActiveCard(MAI_LAN);
        assertNotNull(c);
        assertEquals("Bị khóa", c.getStatus());
    }

    @Test
    @DisplayName("getActiveCard: chỉ có thẻ đã Hết hạn -> null")
    void activeCardExpired() {
        assertNull(dao.getActiveCard(DUC));
    }

    @Test
    @DisplayName("getActiveCard: thẻ đã qua hạn nhưng trạng thái chưa cập nhật -> null")
    void activeCardOverdueNotUpdated() {
        assertNull(dao.getActiveCard(HUNG));
    }

    @Test
    @DisplayName("getActiveCard: bạn đọc chưa làm thẻ lần nào -> null")
    void activeCardNone() {
        assertNull(dao.getActiveCard(AN));
    }

    @Test
    @DisplayName("getActiveCard: id bạn đọc không tồn tại -> null")
    void activeCardNotExist() {
        assertNull(dao.getActiveCard(NOT_EXIST));
    }

    // ---------- addCard ----------

    private ReaderCard7 newCard(int readerId, String code, String cls, int months) {
        Reader7 r = new Reader7();
        r.setId(readerId);
        r.setFullName("Nguyễn Văn An");
        Calendar dob = Calendar.getInstance();
        dob.set(2005, Calendar.MAY, 12);
        r.setDateOfBirth(dob.getTime());
        r.setEmail("annv@stu.ptit.edu.vn");
        r.setPhone("0912345678");
        r.setAddress("Hà Đông, Hà Nội");
        r.setReaderCode(code);
        r.setClassOrUnit(cls);
        ReaderCard7 c = new ReaderCard7();
        c.setCardType("Sinh viên");
        Calendar cal = Calendar.getInstance();
        c.setRegisterDate(cal.getTime());
        cal.add(Calendar.MONTH, months);
        c.setExpiryDate(cal.getTime());
        c.setReader(r);
        return c;
    }

    private int count(String sql, Object... params) throws SQLException {
        try (PreparedStatement ps = dao.con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private String readerCode(int id) throws SQLException {
        try (PreparedStatement ps = dao.con.prepareStatement("SELECT readerCode FROM tblReader7 WHERE tblMember7id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getString(1);
            }
        }
    }

    @Test
    @DisplayName("addCard: bạn đọc làm thẻ lần đầu -> true, có mã thẻ, lưu mã sinh viên")
    void addFirstCard() throws SQLException {
        ReaderCard7 c = newCard(AN, "B23DCCN001", "D23CQCN01-B", 12);
        assertTrue(dao.addCard(c));
        assertTrue(c.getId() > 0);
        assertTrue(c.getCardCode().matches("RC\\d{4}\\d{6}"));
        assertEquals("Còn hiệu lực", c.getStatus());
        assertEquals(1, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ?", AN));
        assertEquals("B23DCCN001", readerCode(AN));
        assertNotNull(dao.getActiveCard(AN));
    }

    @Test
    @DisplayName("addCard: bạn đọc đang có thẻ chưa hết hạn -> false, không thêm thẻ")
    void addWhenActive() throws SQLException {
        int before = count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ?", HA);
        assertFalse(dao.addCard(newCard(HA, "B23DCCN045", "D23CQCN03-B", 12)));
        assertEquals(before, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ?", HA));
    }

    @Test
    @DisplayName("addCard: thẻ Bị khóa chưa hết hạn -> false")
    void addWhenLocked() {
        assertFalse(dao.addCard(newCard(MAI_LAN, "B24DCKT012", "D24CQKT01-B", 12)));
    }

    @Test
    @DisplayName("addCard: thẻ cũ đã qua hạn chưa cập nhật -> true, thẻ cũ chuyển sang Hết hạn")
    void addAfterOverdue() throws SQLException {
        assertTrue(dao.addCard(newCard(HUNG, "B22DCCN150", "D22CQCN02-B", 6)));
        assertEquals(1, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE cardCode = 'RC2025000350' AND status = 'Hết hạn'"));
        assertEquals(1, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ? AND status <> 'Hết hạn'", HUNG));
    }

    @Test
    @DisplayName("addCard: mã sinh viên trùng với bạn đọc khác -> false, không thay đổi dữ liệu")
    void addDuplicateReaderCode() throws SQLException {
        assertFalse(dao.addCard(newCard(AN, "B23DCCN112", "D23CQCN01-B", 12)));
        assertNull(readerCode(AN));
        assertEquals(0, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ?", AN));
    }

    @Test
    @DisplayName("addCard: gọi hai lần liên tiếp cho cùng bạn đọc -> lần 2 trả về false")
    void addTwice() throws SQLException {
        assertTrue(dao.addCard(newCard(AN, "B23DCCN001", "D23CQCN01-B", 12)));
        assertFalse(dao.addCard(newCard(AN, "B23DCCN001", "D23CQCN01-B", 12)));
        assertEquals(1, count("SELECT COUNT(*) FROM tblReaderCard7 WHERE tblReader7id = ?", AN));
    }

    @Test
    @DisplayName("addCard: bạn đọc không tồn tại -> false")
    void addReaderNotExist() {
        assertFalse(dao.addCard(newCard(NOT_EXIST, "B99DCCN999", "D99", 12)));
    }

    @Test
    @DisplayName("addCard: thẻ null hoặc không có bạn đọc -> false")
    void addNull() {
        assertFalse(dao.addCard(null));
        assertFalse(dao.addCard(new ReaderCard7()));
    }
}
