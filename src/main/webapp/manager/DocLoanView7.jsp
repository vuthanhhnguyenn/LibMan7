<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Manager7 manager = (Manager7) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
    // documentId lấy từ URL; khoảng ngày và kết quả thống kê lấy từ session
    String idText = request.getParameter("documentId");
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    ArrayList<DocStat7> listDocStat = (ArrayList<DocStat7>) session.getAttribute("listDocStat");
    DocStat7 docStat = null;
    if (listDocStat != null) {
        for (DocStat7 s : listDocStat) {
            if (String.valueOf(s.getId()).equals(idText)) docStat = s;
        }
    }
    if (docStat == null) {
        // mất kết quả thống kê (phiên mới, mở link ở trình duyệt khác, sửa id trên URL)
        response.sendRedirect("DocStatView7.jsp?lost=1");
        return;
    }
    ArrayList<LoanReceipt7> listLoan = null;
    LoanReceiptDAO7 dao = null;
    try {
        dao = new LoanReceiptDAO7();
        listLoan = dao.getLoansOfDoc(docStat.getId(), startDate, endDate);
        session.setAttribute("lastDocumentId", docStat.getId());
    } catch (RuntimeException e) {
        // listLoan = null: báo lỗi bên dưới
    } finally {
        if (dao != null) dao.close();
    }
%>
<html>
<head><title>LibMan - Các lần mượn của tài liệu</title></head>
<body>
<h2>CÁC LẦN MƯỢN CỦA TÀI LIỆU</h2>
<p>Mã tài liệu: <b><%= h(docStat.getDocumentCode()) %></b><br>
Tên tài liệu: <b><%= h(docStat.getTitle()) %></b><br>
Thời gian: <%= d(startDate) %> - <%= d(endDate) %><br>
Tổng số lần mượn: <b><%= docStat.getTotalLoan() %></b></p>
<% if (listLoan == null) { %>
<p><b>Không lấy được dữ liệu, vui lòng thử lại.</b></p>
<% } else { %>
<table border="1" cellpadding="4" cellspacing="0" id="tblLoan">
    <tr><th>STT</th><th>Mã phiếu</th><th>Ngày mượn</th><th>Bạn đọc</th><th>Mã vạch bản sao</th><th>Hạn trả</th><th>Trạng thái</th></tr>
    <% int i = 0;
       for (LoanReceipt7 r : listLoan) {
           for (LoanLine7 line : r.getLoanLines()) { i++; %>
    <tr>
        <td><%= i %></td>
        <td><a href="LoanReceiptView7.jsp?receiptId=<%= r.getId() %>"><%= receiptCode(r.getId()) %></a></td>
        <td><%= d(r.getLoanDate()) %></td>
        <td><%= h(r.getReader().getReaderCode()) %> - <%= h(r.getReader().getFullName()) %></td>
        <td><%= h(line.getCopy().getBarcode()) %></td>
        <td><%= d(line.getDueDate()) %></td>
        <td><%= h(line.getStatus()) %></td>
    </tr>
    <% } } %>
</table>
<% } %>
<p><a id="btnBack" href="DocStatView7.jsp">Quay lại</a></p>
</body>
</html>
