package model;

/** Kết quả thống kê bạn đọc theo số lần mượn (không lưu CSDL). */
public class ReaderStat7 extends Reader7 {
    private static final long serialVersionUID = 1L;
    private int totalLoan;

    public ReaderStat7() {
        super();
    }

    public int getTotalLoan() {
        return totalLoan;
    }

    public void setTotalLoan(int totalLoan) {
        this.totalLoan = totalLoan;
    }
}
