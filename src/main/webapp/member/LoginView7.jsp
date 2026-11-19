<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    String msg = "";
    if (request.getParameter("err") != null) msg = "Sai tên đăng nhập hoặc mật khẩu.";
    if (request.getParameter("expired") != null) msg = "Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.";
    if (request.getParameter("db") != null) msg = "Không kết nối được cơ sở dữ liệu, vui lòng thử lại sau.";
    if (request.getParameter("role") != null) msg = "Tài khoản của bạn không có quyền vào trang vừa mở.";
    if (request.getParameter("out") != null) msg = "Bạn đã đăng xuất.";
%>
<html>
<head><title>LibMan - Đăng nhập</title></head>
<body>
<h2>THƯ VIỆN LIBMAN - ĐĂNG NHẬP</h2>
<p><b><%= msg %></b></p>
<form method="post" action="doLogin7.jsp">
    <table>
        <tr><td>Tên đăng nhập:</td><td><input type="text" name="username" value="<%= h(request.getParameter("username")) %>" required></td></tr>
        <tr><td>Mật khẩu:</td><td><input type="password" name="password" required></td></tr>
        <tr><td></td><td><input type="submit" value="Đăng nhập"></td></tr>
    </table>
</form>
</body>
</html>
