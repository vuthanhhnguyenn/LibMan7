package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/** Phiếu mượn. */
public class LoanReceipt7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private Date loanDate;
    private String note;
    private Reader7 reader;
    private Librarian7 librarian;
    private ArrayList<LoanLine7> loanLines = new ArrayList<>();

    public LoanReceipt7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(Date loanDate) {
        this.loanDate = loanDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Reader7 getReader() {
        return reader;
    }

    public void setReader(Reader7 reader) {
        this.reader = reader;
    }

    public Librarian7 getLibrarian() {
        return librarian;
    }

    public void setLibrarian(Librarian7 librarian) {
        this.librarian = librarian;
    }

    public ArrayList<LoanLine7> getLoanLines() {
        return loanLines;
    }

    public void setLoanLines(ArrayList<LoanLine7> loanLines) {
        this.loanLines = loanLines;
    }

    /** Mã phiếu hiển thị, ví dụ id 412 thành PM0412. */
    public String getReceiptCode() {
        return String.format("PM%04d", id);
    }

    /** Tổng tiền phạt của các dòng mượn trong phiếu. */
    public float getTotalFine() {
        float total = 0;
        for (LoanLine7 line : loanLines) {
            total += line.getFine();
        }
        return total;
    }
}
