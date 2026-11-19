package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

import model.Document7;
import model.DocumentCopy7;
import model.Librarian7;
import model.LoanLine7;
import model.LoanReceipt7;
import model.Reader7;

public class LoanReceiptDAO7 extends DAO7 {

    /**
     * Trạng thái dòng mượn tại lúc xem: dòng còn đang mượn mà đã qua hạn trả
     * thì hiện là Quá hạn, kể cả khi CSDL chưa kịp cập nhật.
     */
    private static final String STATUS_NOW =
            "CASE WHEN ll.status = 'Đang mượn' AND ll.dueDate < CURRENT_DATE THEN 'Quá hạn' ELSE ll.status END";

    public LoanReceiptDAO7() {
        super();
    }

    /**
     * Lấy các phiếu mượn có bản sao của tài liệu với ngày mượn trong khoảng đã chọn,
     * kèm bạn đọc và các dòng mượn thuộc tài liệu đó, xếp theo ngày mượn.
     */
    public ArrayList<LoanReceipt7> getLoansOfDoc(int documentId, Date startDate, Date endDate) {
        String sql = "SELECT lr.id AS receiptId, lr.loanDate, lr.note, "
                + "m.id AS readerId, m.fullName, r.readerCode, r.classOrUnit, "
                + "ll.id AS lineId, ll.dueDate, ll.returnCondition, ll.fine, " + STATUS_NOW + " AS status, "
                + "c.id AS copyId, c.barcode, c.location "
                + "FROM tblLoanReceipt7 lr "
                + "JOIN tblLoanLine7 ll ON ll.tblLoanReceipt7id = lr.id "
                + "JOIN tblDocumentCopy7 c ON c.id = ll.tblDocumentCopy7id "
                + "JOIN tblReader7 r ON r.tblMember7id = lr.tblReader7id "
                + "JOIN tblMember7 m ON m.id = r.tblMember7id "
                + "WHERE c.tblDocument7id = ? AND lr.loanDate BETWEEN ? AND ? "
                + "ORDER BY lr.loanDate, lr.id, ll.id";
        Map<Integer, LoanReceipt7> map = new LinkedHashMap<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            ps.setDate(2, toSql(startDate));
            ps.setDate(3, toSql(endDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("receiptId");
                    LoanReceipt7 receipt = map.get(id);
                    if (receipt == null) {
                        receipt = new LoanReceipt7();
                        receipt.setId(id);
                        receipt.setLoanDate(rs.getDate("loanDate"));
                        receipt.setNote(rs.getString("note"));
                        receipt.setReader(readReader(rs));
                        map.put(id, receipt);
                    }
                    receipt.getLoanLines().add(readLine(rs, null));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
        return new ArrayList<>(map.values());
    }

    /**
     * Lấy đủ một phiếu mượn: bạn đọc, nhân viên thư viện lập phiếu,
     * mọi dòng mượn kèm bản sao và tài liệu. Không có phiếu thì trả về null.
     */
    public LoanReceipt7 getLoanReceipt(int receiptId) {
        String head = "SELECT lr.id, lr.loanDate, lr.note, "
                + "m.id AS readerId, m.fullName, r.readerCode, r.classOrUnit, "
                + "sm.id AS staffId, sm.fullName AS staffName, s.staffCode, s.position "
                + "FROM tblLoanReceipt7 lr "
                + "JOIN tblReader7 r ON r.tblMember7id = lr.tblReader7id "
                + "JOIN tblMember7 m ON m.id = r.tblMember7id "
                + "JOIN tblStaff7 s ON s.tblMember7id = lr.tblStaff7id "
                + "JOIN tblMember7 sm ON sm.id = s.tblMember7id "
                + "WHERE lr.id = ?";
        String lines = "SELECT ll.id AS lineId, ll.dueDate, ll.returnCondition, ll.fine, " + STATUS_NOW + " AS status, "
                + "c.id AS copyId, c.barcode, c.location, "
                + "d.id AS documentId, d.documentCode, d.title, d.documentType, d.author "
                + "FROM tblLoanLine7 ll "
                + "JOIN tblDocumentCopy7 c ON c.id = ll.tblDocumentCopy7id "
                + "JOIN tblDocument7 d ON d.id = c.tblDocument7id "
                + "WHERE ll.tblLoanReceipt7id = ? ORDER BY ll.id";
        try (PreparedStatement ps = con.prepareStatement(head)) {
            ps.setInt(1, receiptId);
            LoanReceipt7 receipt;
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                receipt = new LoanReceipt7();
                receipt.setId(rs.getInt("id"));
                receipt.setLoanDate(rs.getDate("loanDate"));
                receipt.setNote(rs.getString("note"));
                receipt.setReader(readReader(rs));
                Librarian7 lib = new Librarian7();
                lib.setId(rs.getInt("staffId"));
                lib.setFullName(rs.getString("staffName"));
                lib.setStaffCode(rs.getString("staffCode"));
                lib.setPosition(rs.getString("position"));
                receipt.setLibrarian(lib);
            }
            try (PreparedStatement ps2 = con.prepareStatement(lines)) {
                ps2.setInt(1, receiptId);
                try (ResultSet rs = ps2.executeQuery()) {
                    while (rs.next()) {
                        Document7 d = new Document7();
                        d.setId(rs.getInt("documentId"));
                        d.setDocumentCode(rs.getString("documentCode"));
                        d.setTitle(rs.getString("title"));
                        d.setDocumentType(rs.getString("documentType"));
                        d.setAuthor(rs.getString("author"));
                        receipt.getLoanLines().add(readLine(rs, d));
                    }
                }
            }
            return receipt;
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
    }

    private static Reader7 readReader(ResultSet rs) throws SQLException {
        Reader7 r = new Reader7();
        r.setId(rs.getInt("readerId"));
        r.setFullName(rs.getString("fullName"));
        r.setReaderCode(rs.getString("readerCode"));
        r.setClassOrUnit(rs.getString("classOrUnit"));
        return r;
    }

    private static LoanLine7 readLine(ResultSet rs, Document7 d) throws SQLException {
        DocumentCopy7 copy = new DocumentCopy7();
        copy.setId(rs.getInt("copyId"));
        copy.setBarcode(rs.getString("barcode"));
        copy.setLocation(rs.getString("location"));
        copy.setDocument(d);
        LoanLine7 line = new LoanLine7();
        line.setId(rs.getInt("lineId"));
        line.setCopy(copy);
        line.setDueDate(rs.getDate("dueDate"));
        line.setReturnCondition(rs.getString("returnCondition"));
        line.setFine(rs.getFloat("fine"));
        line.setStatus(rs.getString("status"));
        return line;
    }
}
