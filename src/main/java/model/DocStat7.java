package model;

/** Kết quả thống kê tài liệu theo số lần mượn (không lưu CSDL). */
public class DocStat7 extends Document7 {
    private static final long serialVersionUID = 1L;
    private int totalLoan;

    public DocStat7() {
        super();
    }

    public int getTotalLoan() {
        return totalLoan;
    }

    public void setTotalLoan(int totalLoan) {
        this.totalLoan = totalLoan;
    }
}
