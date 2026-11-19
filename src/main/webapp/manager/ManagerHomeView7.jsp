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
<head><title>LibMan - Trang chủ nhân viên quản lý</title></head>
<body>
<h2>TRANG CHỦ NHÂN VIÊN QUẢN LÝ</h2>
<p>Xin chào: <b><%= h(manager.getFullName()) %></b></p>
<ul>
    <li><a id="btnViewReport" href="ReportSelectView7.jsp">Xem báo cáo</a></li>
    <li><a href="<%= request.getContextPath() %>/member/doLogout7.jsp">Đăng xuất</a></li>
</ul>
</body>
</html>
