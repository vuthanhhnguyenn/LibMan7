package dao;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import model.Reader7;

class TestReaderDAO7 {
    ReaderDAO7 dao;

    @BeforeEach
    void setUp() {
        try {
            dao = new ReaderDAO7();
        } catch (IllegalStateException e) {
            Assumptions.abort("Chưa có CSDL libman7, bỏ qua kiểm thử");
        }
    }

    @AfterEach
    void tearDown() {
        if (dao != null) dao.close();
    }

    @Test
    @DisplayName("Bạn đọc chưa làm thẻ: đủ thông tin cá nhân, mã sinh viên và lớp để trống")
    void readerWithoutCode() {
        Reader7 r = dao.getReader(3);
        assertNotNull(r);
        assertEquals("Nguyễn Văn An", r.getFullName());
        assertEquals("annv@stu.ptit.edu.vn", r.getEmail());
        assertNull(r.getReaderCode());
        assertNull(r.getClassOrUnit());
    }

    @Test
    @DisplayName("Bạn đọc đã có mã sinh viên")
    void readerWithCode() {
        assertEquals("B23DCCN112", dao.getReader(4).getReaderCode());
    }

    @Test
    @DisplayName("id của nhân viên hoặc id không tồn tại -> null")
    void notReader() {
        assertNull(dao.getReader(1));
        assertNull(dao.getReader(9999));
    }
}
