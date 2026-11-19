package dao;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import model.Librarian7;
import model.Manager7;
import model.Member7;
import model.Reader7;

class TestMemberDAO7 {
    MemberDAO7 dao;

    @BeforeEach
    void setUp() {
        try {
            dao = new MemberDAO7();
        } catch (IllegalStateException e) {
            Assumptions.abort("Chưa có CSDL libman7, bỏ qua kiểm thử");
        }
    }

    @AfterEach
    void tearDown() {
        if (dao != null) dao.close();
    }

    @Test
    @DisplayName("Đúng tài khoản bạn đọc -> Reader7")
    void loginReader() {
        Member7 m = dao.checkLogin("annv", "Libman@123");
        assertInstanceOf(Reader7.class, m);
        assertEquals("Nguyễn Văn An", m.getFullName());
    }

    @Test
    @DisplayName("Đúng tài khoản nhân viên quản lý -> Manager7")
    void loginManager() {
        assertInstanceOf(Manager7.class, dao.checkLogin("binhtt", "Libman@123"));
    }

    @Test
    @DisplayName("Đúng tài khoản nhân viên thư viện -> Librarian7")
    void loginLibrarian() {
        assertInstanceOf(Librarian7.class, dao.checkLogin("lanht", "Libman@123"));
    }

    @Test
    @DisplayName("Sai mật khẩu, tài khoản không tồn tại, để trống -> null")
    void loginWrong() {
        assertNull(dao.checkLogin("annv", "sai-mat-khau"));
        assertNull(dao.checkLogin("khongco", "Libman@123"));
        assertNull(dao.checkLogin("", ""));
        assertNull(dao.checkLogin(null, null));
    }

    @Test
    @DisplayName("Chuỗi chèn SQL -> null")
    void loginInjection() {
        assertNull(dao.checkLogin("annv' OR '1'='1", "x' OR '1'='1"));
    }
}
