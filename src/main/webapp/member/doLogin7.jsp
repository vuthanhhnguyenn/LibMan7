<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    String ctx = request.getContextPath();
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if (username == null || password == null) {
        response.sendRedirect("LoginView7.jsp");
        return;
    }
    Member7 member;
    MemberDAO7 dao = null;
    try {
        dao = new MemberDAO7();
        member = dao.checkLogin(username, password);
    } catch (RuntimeException e) {
        response.sendRedirect("LoginView7.jsp?db=1");
        return;
    } finally {
        if (dao != null) dao.close();
    }
    if (member == null) {
        response.sendRedirect("LoginView7.jsp?err=1&username=" + java.net.URLEncoder.encode(username, "UTF-8"));
        return;
    }
    // Tạo phiên mới sau khi đăng nhập
    session.invalidate();
    HttpSession s = request.getSession(true);
    if (member instanceof Reader7) {
        s.setAttribute("reader", member);
        response.sendRedirect(ctx + "/reader/ReaderHomeView7.jsp");
    } else if (member instanceof Manager7) {
        s.setAttribute("manager", member);
        response.sendRedirect(ctx + "/manager/ManagerHomeView7.jsp");
    } else {
        s.setAttribute("librarian", member);
        response.sendRedirect(ctx + "/librarian/LibrarianHomeView7.jsp");
    }
%>
