<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Manager7 manager = (Manager7) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
    LoanReceipt7 receipt = null;
    String error = "Không tìm thấy phiếu mượn.";
    LoanReceiptDAO7 dao = null;
    try {
        dao = new LoanReceiptDAO7();
        receipt = dao.getLoanReceipt(Integer.parseInt(request.getParameter("receiptId")));
    } catch (NumberFormatException e) {
        // mã phiếu trên URL không phải số: coi như không tìm thấy
    } catch (RuntimeException e) {
        error = "Không lấy được dữ liệu, vui lòng thử lại.";
    } finally {
        if (dao != null) dao.close();
    }
    Integer lastDocumentId = (Integer) session.getAttribute("lastDocumentId");
    String back = lastDocumentId != null ? "DocLoanView7.jsp?documentId=" + lastDocumentId : "DocStatView7.jsp";
%>
<html>
<head><title>LibMan - Chi tiết phiếu mượn</title></head>
<body>
<h2>CHI TIẾT PHIẾU MƯỢN</h2>
<% if (receipt == null) { %>
<p><b><%= error %></b></p>
<% } else { %>
<p>Mã phiếu: <b><%= receipt.getReceiptCode() %></b><br>
Ngày mượn: <%= d(receipt.getLoanDate()) %><br>
Bạn đọc: <%= h(receipt.getReader().getReaderCode()) %> - <%= h(receipt.getReader().getFullName()) %>,
lớp <%= h(receipt.getReader().getClassOrUnit()) %><br>
Nhân viên thư viện: <%= h(receipt.getLibrarian().getStaffCode()) %> - <%= h(receipt.getLibrarian().getFullName()) %><br>
Ghi chú: <%= receipt.getNote() == null ? "không" : h(receipt.getNote()) %></p>
<table border="1" cellpadding="4" cellspacing="0" id="tblLoanLine">
    <tr><th>STT</th><th>Mã vạch</th><th>Tên tài liệu</th><th>Hạn trả</th><th>Trạng thái</th><th>Tình trạng trả</th><th>Tiền phạt (đ)</th></tr>
    <% int i = 0;
       for (LoanLine7 line : receipt.getLoanLines()) { i++; %>
    <tr>
        <td><%= i %></td>
        <td><%= h(line.getCopy().getBarcode()) %></td>
        <td><%= h(line.getCopy().getDocument().getTitle()) %></td>
        <td><%= d(line.getDueDate()) %></td>
        <td><%= h(line.getStatus()) %></td>
        <td><%= h(line.getReturnCondition()) %></td>
        <td align="right"><%= money(line.getFine()) %></td>
    </tr>
    <% } %>
</table>
<p>Tổng tiền phạt: <%= money(receipt.getTotalFine()) %> đ</p>
<% } %>
<a id="btnBack" href="<%= back %>">Quay lại</a>
</body>
</html>
