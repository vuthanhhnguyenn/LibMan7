<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Librarian7 librarian = (Librarian7) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
%>
<html>
<head><title>LibMan - Nhân viên thư viện</title></head>
<body>
<h2>TRANG CHỦ NHÂN VIÊN THƯ VIỆN</h2>
<p>Xin chào: <b><%= h(librarian.getFullName()) %></b></p>
<p>Các chức năng của nhân viên thư viện không thuộc 2 module được cài đặt.</p>
<a href="<%= request.getContextPath() %>/member/doLogout7.jsp">Đăng xuất</a>
</body>
</html>
