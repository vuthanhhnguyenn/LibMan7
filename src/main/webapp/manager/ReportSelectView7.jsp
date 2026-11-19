<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Manager7 manager = (Manager7) session.getAttribute("manager");
    if (manager == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
%>
<html>
<head><title>LibMan - Chọn loại báo cáo</title></head>
<body>
<h2>CHỌN LOẠI BÁO CÁO</h2>
<ol>
    <li><a id="lnkDocStat" href="DocStatView7.jsp?new=1">Thống kê tài liệu theo số lần mượn</a></li>
    <li>Thống kê bạn đọc theo số lần mượn (module khác, chưa cài đặt)</li>
    <li>Thống kê nhà cung cấp theo số lượng tài liệu nhập (module khác, chưa cài đặt)</li>
</ol>
<a id="btnBack" href="ManagerHomeView7.jsp">Quay lại</a>
</body>
</html>
