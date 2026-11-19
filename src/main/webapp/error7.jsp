<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<% Integer code = (Integer) request.getAttribute("jakarta.servlet.error.status_code"); %>
<html>
<head><title>LibMan - Lỗi</title></head>
<body>
<h2>THƯ VIỆN LIBMAN</h2>
<p><%= (code != null && code == 404) ? "Không tìm thấy trang yêu cầu." : "Hệ thống đang gặp sự cố, vui lòng thử lại sau." %></p>
<a href="<%= request.getContextPath() %>/index.jsp">Về trang chủ</a>
</body>
</html>
