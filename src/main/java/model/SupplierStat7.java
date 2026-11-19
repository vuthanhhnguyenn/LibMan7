package model;

/** Kết quả thống kê nhà cung cấp (không lưu CSDL). */
public class SupplierStat7 extends Supplier7 {
    private static final long serialVersionUID = 1L;
    private int totalQuantity;
    private float totalValue;

    public SupplierStat7() {
        super();
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public float getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(float totalValue) {
        this.totalValue = totalValue;
    }
}
