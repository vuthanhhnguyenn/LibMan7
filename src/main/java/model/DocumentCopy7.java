package model;

import java.io.Serializable;

/** Bản sao vật lý của một tài liệu. */
public class DocumentCopy7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String barcode;
    private String location;
    private String status;
    private Document7 document;

    public DocumentCopy7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Document7 getDocument() {
        return document;
    }

    public void setDocument(Document7 document) {
        this.document = document;
    }
}
