package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import model.DocStat7;

public class DocStatDAO7 extends DAO7 {

    public DocStatDAO7() {
        super();
    }

    /**
     * Đếm số lần mượn của từng tài liệu trong khoảng ngày (tính cả hai đầu).
     * Mỗi lần mượn là một dòng mượn có ngày mượn của phiếu nằm trong khoảng.
     * Xếp giảm dần theo số lần mượn, bằng nhau thì theo mã tài liệu.
     * Tài liệu không có lượt mượn nào trong khoảng thì không có trong kết quả.
     */
    public ArrayList<DocStat7> getDocStat(Date startDate, Date endDate) {
        String sql = "SELECT d.id, d.documentCode, d.title, d.documentType, d.author, d.publisher, d.publishYear, "
                + "COUNT(ll.id) AS totalLoan "
                + "FROM tblDocument7 d "
                + "JOIN tblDocumentCopy7 c ON c.tblDocument7id = d.id "
                + "JOIN tblLoanLine7 ll ON ll.tblDocumentCopy7id = c.id "
                + "JOIN tblLoanReceipt7 lr ON lr.id = ll.tblLoanReceipt7id "
                + "WHERE lr.loanDate BETWEEN ? AND ? "
                + "GROUP BY d.id, d.documentCode, d.title, d.documentType, d.author, d.publisher, d.publishYear "
                + "ORDER BY totalLoan DESC, d.documentCode";
        ArrayList<DocStat7> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, toSql(startDate));
            ps.setDate(2, toSql(endDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DocStat7 s = new DocStat7();
                    s.setId(rs.getInt("id"));
                    s.setDocumentCode(rs.getString("documentCode"));
                    s.setTitle(rs.getString("title"));
                    s.setDocumentType(rs.getString("documentType"));
                    s.setAuthor(rs.getString("author"));
                    s.setPublisher(rs.getString("publisher"));
                    s.setPublishYear(rs.getInt("publishYear"));
                    s.setTotalLoan(rs.getInt("totalLoan"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Lỗi truy vấn CSDL", e);
        }
        return list;
    }
}
