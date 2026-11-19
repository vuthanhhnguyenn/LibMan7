<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Reader7 reader = (Reader7) session.getAttribute("reader");
    if (reader == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
%>
<html>
<head><title>LibMan - Trang chủ bạn đọc</title></head>
<body>
<h2>TRANG CHỦ BẠN ĐỌC</h2>
<p>Xin chào: <b><%= h(reader.getFullName()) %></b></p>
<ul>
    <li>Tìm kiếm tài liệu (module khác, chưa cài đặt)</li>
    <li><a id="btnRegisterCard" href="RegisterCardView7.jsp">Đăng ký làm thẻ bạn đọc</a></li>
    <li><a href="<%= request.getContextPath() %>/member/doLogout7.jsp">Đăng xuất</a></li>
</ul>
</body>
</html>
