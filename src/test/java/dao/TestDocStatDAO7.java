package dao;

import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import model.DocStat7;

class TestDocStatDAO7 {
    DocStatDAO7 dao;

    static Date day(String s) throws Exception {
        return new SimpleDateFormat("yyyy-MM-dd").parse(s);
    }

    @BeforeEach
    void setUp() throws SQLException {
        try {
            dao = new DocStatDAO7();
        } catch (IllegalStateException e) {
            Assumptions.abort("Chưa có CSDL libman7, bỏ qua kiểm thử");
        }
    }

    @AfterEach
    void tearDown() {
        if (dao != null) dao.close();
    }

    @Test
    @DisplayName("Tháng 9/2026: 5 tài liệu, 24 lượt, xếp giảm dần theo số lần mượn")
    void september() throws Exception {
        ArrayList<DocStat7> list = dao.getDocStat(day("2026-09-01"), day("2026-09-30"));
        assertEquals(5, list.size());
        String[] codes = {"TL0012", "TL0031", "TL0007", "TL0054", "TL0020"};
        int[] totals = {8, 6, 5, 3, 2};
        int sum = 0;
        for (int i = 0; i < 5; i++) {
            assertEquals(codes[i], list.get(i).getDocumentCode());
            assertEquals(totals[i], list.get(i).getTotalLoan());
            sum += list.get(i).getTotalLoan();
        }
        assertEquals(24, sum);
        assertEquals("Giáo trình Cơ sở dữ liệu", list.get(0).getTitle());
    }

    @Test
    @DisplayName("Khoảng ngày không có lượt mượn -> danh sách rỗng")
    void noLoans() throws Exception {
        assertTrue(dao.getDocStat(day("2026-08-01"), day("2026-08-15")).isEmpty());
    }

    @Test
    @DisplayName("Số lần mượn bằng nhau thì xếp theo mã tài liệu")
    void tieOrderedByCode() throws Exception {
        ArrayList<DocStat7> list = dao.getDocStat(day("2026-09-02"), day("2026-09-02"));
        assertEquals(3, list.size());
        assertEquals("TL0007", list.get(0).getDocumentCode());
        assertEquals("TL0012", list.get(1).getDocumentCode());
        assertEquals("TL0031", list.get(2).getDocumentCode());
    }

    @Test
    @DisplayName("Tính cả ngày bắt đầu và ngày kết thúc")
    void inclusiveBounds() throws Exception {
        ArrayList<DocStat7> list = dao.getDocStat(day("2026-09-27"), day("2026-09-27"));
        assertEquals(2, list.size());   // PM0459: CSDL-0012-01 và TRR-0007-04
    }

    @Test
    @DisplayName("Ngày bắt đầu sau ngày kết thúc -> danh sách rỗng")
    void reversedRange() throws Exception {
        assertTrue(dao.getDocStat(day("2026-09-30"), day("2026-09-01")).isEmpty());
    }

    @Test
    @DisplayName("Phiếu ngoài khoảng ngày không bị tính (tháng 8 có 2 lượt)")
    void outsideRangeExcluded() throws Exception {
        ArrayList<DocStat7> list = dao.getDocStat(day("2026-08-16"), day("2026-08-31"));
        assertEquals(2, list.size());
        for (DocStat7 s : list) assertEquals(1, s.getTotalLoan());
    }
}
