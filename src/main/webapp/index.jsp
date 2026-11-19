<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Đã đăng nhập thì về trang chủ theo vai trò, chưa thì sang trang đăng nhập
    String ctx = request.getContextPath();
    if (session.getAttribute("reader") != null) {
        response.sendRedirect(ctx + "/reader/ReaderHomeView7.jsp");
    } else if (session.getAttribute("manager") != null) {
        response.sendRedirect(ctx + "/manager/ManagerHomeView7.jsp");
    } else if (session.getAttribute("librarian") != null) {
        response.sendRedirect(ctx + "/librarian/LibrarianHomeView7.jsp");
    } else {
        response.sendRedirect(ctx + "/member/LoginView7.jsp");
    }
%>
