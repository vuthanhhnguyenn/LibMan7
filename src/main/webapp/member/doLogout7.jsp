<%@ page contentType="text/html; charset=UTF-8" %>
<%
    session.invalidate();
    response.sendRedirect("LoginView7.jsp?out=1");
%>
