package model;

/** Bạn đọc. readerCode và classOrUnit để trống cho tới khi làm thẻ lần đầu. */
public class Reader7 extends Member7 {
    private static final long serialVersionUID = 1L;
    private String readerCode;
    private String classOrUnit;

    public Reader7() {
        super();
    }

    public String getReaderCode() {
        return readerCode;
    }

    public void setReaderCode(String readerCode) {
        this.readerCode = readerCode;
    }

    public String getClassOrUnit() {
        return classOrUnit;
    }

    public void setClassOrUnit(String classOrUnit) {
        this.classOrUnit = classOrUnit;
    }
}
