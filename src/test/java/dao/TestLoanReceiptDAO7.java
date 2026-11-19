package dao;

import static org.junit.jupiter.api.Assertions.*;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import model.LoanLine7;
import model.LoanReceipt7;

class TestLoanReceiptDAO7 {
    LoanReceiptDAO7 dao;

    static Date day(String s) throws Exception {
        return new SimpleDateFormat("yyyy-MM-dd").parse(s);
    }

    @BeforeEach
    void setUp() {
        try {
            dao = new LoanReceiptDAO7();
        } catch (IllegalStateException e) {
            Assumptions.abort("Chưa có CSDL libman7, bỏ qua kiểm thử");
        }
    }

    @AfterEach
    void tearDown() {
        if (dao != null) dao.close();
    }

    @Test
    @DisplayName("getLoansOfDoc: TL0012 tháng 9 -> 8 phiếu, xếp theo ngày mượn, chỉ có dòng của TL0012")
    void loansOfDoc() throws Exception {
        ArrayList<LoanReceipt7> list = dao.getLoansOfDoc(12, day("2026-09-01"), day("2026-09-30"));
        assertEquals(8, list.size());
        assertEquals("PM0412", list.get(0).getReceiptCode());
        assertEquals("PM0459", list.get(7).getReceiptCode());
        assertEquals("Trần Minh Khoa", list.get(0).getReader().getFullName());
        for (int i = 1; i < list.size(); i++) {
            assertFalse(list.get(i).getLoanDate().before(list.get(i - 1).getLoanDate()));
        }
        for (LoanReceipt7 r : list) {
            assertEquals(1, r.getLoanLines().size());   // PM0412 có 3 dòng nhưng chỉ 1 dòng của TL0012
            assertTrue(r.getLoanLines().get(0).getCopy().getBarcode().startsWith("CSDL-0012"));
        }
    }

    @Test
    @DisplayName("getLoansOfDoc: dòng quá hạn chưa trả có trạng thái Quá hạn")
    void overdueStatus() throws Exception {
        ArrayList<LoanReceipt7> list = dao.getLoansOfDoc(12, day("2026-09-14"), day("2026-09-14"));
        assertEquals(1, list.size());
        assertEquals("Quá hạn", list.get(0).getLoanLines().get(0).getStatus());
    }

    @Test
    @DisplayName("getLoansOfDoc: tài liệu không có lượt mượn trong khoảng -> rỗng")
    void noLoansOfDoc() throws Exception {
        assertTrue(dao.getLoansOfDoc(3, day("2026-09-01"), day("2026-09-30")).isEmpty());
    }

    @Test
    @DisplayName("getLoansOfDoc: id tài liệu không tồn tại -> rỗng")
    void docNotExist() throws Exception {
        assertTrue(dao.getLoansOfDoc(9999, day("2026-09-01"), day("2026-09-30")).isEmpty());
    }

    @Test
    @DisplayName("getLoanReceipt: PM0412 -> đủ bạn đọc, nhân viên, 3 dòng, phạt 5.000")
    void receiptDetail() {
        LoanReceipt7 r = dao.getLoanReceipt(412);
        assertNotNull(r);
        assertEquals("B23DCCN112", r.getReader().getReaderCode());
        assertEquals("D23CQCN04-B", r.getReader().getClassOrUnit());
        assertEquals("NV005", r.getLibrarian().getStaffCode());
        assertEquals("Hoàng Thị Lan", r.getLibrarian().getFullName());
        assertEquals(3, r.getLoanLines().size());
        assertEquals(5000f, r.getTotalFine(), 0.01);
        LoanLine7 last = r.getLoanLines().get(2);
        assertEquals("Toán rời rạc", last.getCopy().getDocument().getTitle());
        assertEquals("Rách bìa", last.getReturnCondition());
    }

    @Test
    @DisplayName("getLoanReceipt: phiếu không tồn tại -> null")
    void receiptNotExist() {
        assertNull(dao.getLoanReceipt(99999));
    }
}
