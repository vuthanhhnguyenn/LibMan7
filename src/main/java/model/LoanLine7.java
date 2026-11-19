package model;

import java.io.Serializable;
import java.util.Date;

/** Dòng mượn: một bản sao trong một phiếu mượn. */
public class LoanLine7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private DocumentCopy7 copy;
    private Date dueDate;
    private String returnCondition;
    private float fine;
    private String status;

    public LoanLine7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public DocumentCopy7 getCopy() {
        return copy;
    }

    public void setCopy(DocumentCopy7 copy) {
        this.copy = copy;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getReturnCondition() {
        return returnCondition;
    }

    public void setReturnCondition(String returnCondition) {
        this.returnCondition = returnCondition;
    }

    public float getFine() {
        return fine;
    }

    public void setFine(float fine) {
        this.fine = fine;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
