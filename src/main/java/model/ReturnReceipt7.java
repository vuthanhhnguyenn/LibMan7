package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/** Phiếu trả: gom các dòng mượn được trả cùng lúc. */
public class ReturnReceipt7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private Date returnDate;
    private float totalFine;
    private Librarian7 librarian;
    private ArrayList<LoanLine7> loanLines = new ArrayList<>();

    public ReturnReceipt7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public float getTotalFine() {
        return totalFine;
    }

    public void setTotalFine(float totalFine) {
        this.totalFine = totalFine;
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
}
