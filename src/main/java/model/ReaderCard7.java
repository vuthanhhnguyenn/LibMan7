package model;

import java.io.Serializable;
import java.util.Date;

/** Thẻ bạn đọc. */
public class ReaderCard7 implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String cardCode;
    private String cardType;
    private Date registerDate;
    private Date expiryDate;
    private String status;
    private Reader7 reader;

    public ReaderCard7() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCardCode() {
        return cardCode;
    }

    public void setCardCode(String cardCode) {
        this.cardCode = cardCode;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public Date getRegisterDate() {
        return registerDate;
    }

    public void setRegisterDate(Date registerDate) {
        this.registerDate = registerDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Reader7 getReader() {
        return reader;
    }

    public void setReader(Reader7 reader) {
        this.reader = reader;
    }
}
