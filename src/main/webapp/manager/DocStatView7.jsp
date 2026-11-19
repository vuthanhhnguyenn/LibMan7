<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Manager7 manager = (Manager7) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
    // Vào từ trang chọn báo cáo thì xóa kết quả cũ
    if (request.getParameter("new") != null) {
        session.removeAttribute("startDate");
        session.removeAttribute("endDate");
        session.removeAttribute("listDocStat");
    }
    String error = "";
    if (request.getParameter("lost") != null) error = "Kết quả thống kê không còn, vui lòng chọn lại khoảng ngày.";

    // Bấm Thống kê: trang gửi về chính nó, kiểm tra khoảng ngày rồi gọi DAO
    if (request.getParameter("btnStatistic") != null) {
        session.removeAttribute("listDocStat");
        Date startDate = parseIso(request.getParameter("txtStartDate"));
        Date endDate = parseIso(request.getParameter("txtEndDate"));
        if (startDate == null || endDate == null) {
            error = "Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.";
        } else if (startDate.after(endDate)) {
            error = "Ngày bắt đầu phải trước hoặc trùng ngày kết thúc.";
        } else {
            DocStatDAO7 dao = null;
            try {
                dao = new DocStatDAO7();
                session.setAttribute("listDocStat", dao.getDocStat(startDate, endDate));
                session.setAttribute("startDate", startDate);
                session.setAttribute("endDate", endDate);
            } catch (RuntimeException e) {
                error = "Không lấy được dữ liệu, vui lòng thử lại.";
            } finally {
                if (dao != null) dao.close();
            }
        }
    }
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    ArrayList<DocStat7> listDocStat = (ArrayList<DocStat7>) session.getAttribute("listDocStat");
    String startText = request.getParameter("txtStartDate") != null ? request.getParameter("txtStartDate") : iso(startDate);
    String endText = request.getParameter("txtEndDate") != null ? request.getParameter("txtEndDate") : iso(endDate);
%>
<html>
<head><title>LibMan - Thống kê tài liệu theo số lần mượn</title></head>
<body>
<h2>THỐNG KÊ TÀI LIỆU THEO SỐ LẦN MƯỢN</h2>
<form method="get" action="DocStatView7.jsp">
    Từ ngày: <input type="date" id="txtStartDate" name="txtStartDate" value="<%= h(startText) %>">
    Đến ngày: <input type="date" id="txtEndDate" name="txtEndDate" value="<%= h(endText) %>">
    <input type="submit" id="btnStatistic" name="btnStatistic" value="Thống kê">
</form>
<p><b><%= error %></b></p>
<% if (listDocStat != null && listDocStat.isEmpty()) { %>
<p><b>Không có lượt mượn nào trong khoảng ngày đã chọn.</b></p>
<% } else if (listDocStat != null) {
       int total = 0; %>
<table border="1" cellpadding="4" cellspacing="0" id="tblDocStat">
    <tr><th>STT</th><th>Mã TL</th><th>Tên tài liệu</th><th>Loại</th><th>Tác giả</th><th>Số lần mượn</th></tr>
    <% for (int i = 0; i < listDocStat.size(); i++) {
           DocStat7 s = listDocStat.get(i);
           total += s.getTotalLoan(); %>
    <tr>
        <td><%= i + 1 %></td>
        <td><%= h(s.getDocumentCode()) %></td>
        <td><a href="DocLoanView7.jsp?documentId=<%= s.getId() %>"><%= h(s.getTitle()) %></a></td>
        <td><%= h(s.getDocumentType()) %></td>
        <td><%= h(s.getAuthor()) %></td>
        <td align="right"><%= s.getTotalLoan() %></td>
    </tr>
    <% } %>
</table>
<p>Tổng: <%= listDocStat.size() %> tài liệu, <%= total %> lượt mượn (từ <%= d(startDate) %> đến <%= d(endDate) %>).</p>
<% } %>
<a id="btnBack" href="ReportSelectView7.jsp">Quay lại</a>
</body>
</html>
