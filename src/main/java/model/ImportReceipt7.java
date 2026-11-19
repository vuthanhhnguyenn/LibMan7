package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/** Phiếu nhập tài liệu. */
public class ImportReceipt7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private Date importDate;
    private String note;
    private Supplier7 supplier;
    private Librarian7 librarian;
    private ArrayList<ImportLine7> importLines = new ArrayList<>();

    public ImportReceipt7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Supplier7 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier7 supplier) {
        this.supplier = supplier;
    }

    public Librarian7 getLibrarian() {
        return librarian;
    }

    public void setLibrarian(Librarian7 librarian) {
        this.librarian = librarian;
    }

    public ArrayList<ImportLine7> getImportLines() {
        return importLines;
    }

    public void setImportLines(ArrayList<ImportLine7> importLines) {
        this.importLines = importLines;
    }
}
