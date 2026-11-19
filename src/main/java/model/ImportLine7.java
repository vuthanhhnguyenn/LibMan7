package model;

import java.io.Serializable;
import java.util.ArrayList;

/** Dòng nhập: một tài liệu trong phiếu nhập. */
public class ImportLine7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private Document7 document;
    private int quantity;
    private float unitPrice;
    private ArrayList<DocumentCopy7> copies = new ArrayList<>();

    public ImportLine7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Document7 getDocument() {
        return document;
    }

    public void setDocument(Document7 document) {
        this.document = document;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public float getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(float unitPrice) {
        this.unitPrice = unitPrice;
    }

    public ArrayList<DocumentCopy7> getCopies() {
        return copies;
    }

    public void setCopies(ArrayList<DocumentCopy7> copies) {
        this.copies = copies;
    }
}
