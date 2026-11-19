<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Reader7 reader = (Reader7) session.getAttribute("reader");
    if (reader == null) {
        // phiên đã hết hạn: chuyển tới trang đăng nhập
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
    // keep=1: quay lại sau khi đăng ký lỗi, giữ nguyên dữ liệu vừa nhập
    boolean keep = request.getParameter("keep") != null && session.getAttribute("formCardType") != null;
    ReaderCard7 activeCard = null;
    String dbError = null;
    ReaderDAO7 readerDAO = null;
    ReaderCardDAO7 cardDAO = null;
    try {
        if (!keep) {
            readerDAO = new ReaderDAO7();
            reader = readerDAO.getReader(reader.getId());
            session.setAttribute("reader", reader);
            // bạn đọc đã có mã sinh viên / mã cán bộ thì không cho sửa
            session.setAttribute("codeLocked", reader.getReaderCode() != null);
            session.setAttribute("formCardType", "");
            session.setAttribute("formDuration", "");
        }
        cardDAO = new ReaderCardDAO7();
        activeCard = cardDAO.getActiveCard(reader.getId());
    } catch (RuntimeException e) {
        dbError = "Không kết nối được cơ sở dữ liệu, vui lòng thử lại sau.";
    } finally {
        if (readerDAO != null) readerDAO.close();
        if (cardDAO != null) cardDAO.close();
    }
    boolean codeLocked = Boolean.TRUE.equals(session.getAttribute("codeLocked"));
    String cardType = (String) session.getAttribute("formCardType");
    String duration = (String) session.getAttribute("formDuration");
%>
<html>
<head><title>LibMan - Đăng ký làm thẻ bạn đọc</title></head>
<body>
<% if (dbError != null) { %>
<h2>Thông báo</h2>
<p><%= dbError %></p>
<a href="ReaderHomeView7.jsp">OK</a>
<% } else if (activeCard != null) { %>
<h2>Thông báo</h2>
<p>Bạn đang có thẻ bạn đọc chưa hết hạn.<br>
Mã thẻ: <b><%= h(activeCard.getCardCode()) %></b><br>
Trạng thái: <%= h(activeCard.getStatus()) %><br>
Hạn sử dụng: <%= d(activeCard.getExpiryDate()) %><br>
<% if ("Bị khóa".equals(activeCard.getStatus())) { %>
Thẻ đang bị khóa, vui lòng đến quầy thư viện để trả tài liệu quá hạn hoặc nộp phạt.<br>
<% } %>
Không thể đăng ký thêm thẻ mới.</p>
<a href="ReaderHomeView7.jsp">OK</a>
<% } else { %>
<h2>ĐĂNG KÝ LÀM THẺ BẠN ĐỌC</h2>
<p>Kiểm tra lại thông tin cá nhân, chọn loại thẻ, thời hạn rồi bấm Thêm. (*) là thông tin bắt buộc.</p>
<form method="post" action="doRegisterCard7.jsp">
    <table>
        <tr><td>Họ và tên (*):</td>
            <td><input type="text" id="txtFullName" name="txtFullName" maxlength="100" required value="<%= h(reader.getFullName()) %>"></td></tr>
        <tr><td>Ngày sinh (*):</td>
            <td><input type="date" id="txtDateOfBirth" name="txtDateOfBirth" required max="<%= iso(today()) %>" value="<%= iso(reader.getDateOfBirth()) %>"></td></tr>
        <tr><td>Email (*):</td>
            <td><input type="email" id="txtEmail" name="txtEmail" maxlength="100" required value="<%= h(reader.getEmail()) %>"></td></tr>
        <tr><td>Số điện thoại (*):</td>
            <td><input type="text" id="txtPhone" name="txtPhone" maxlength="10" required pattern="0[0-9]{9}"
                       title="10 chữ số, bắt đầu bằng số 0" value="<%= h(reader.getPhone()) %>"></td></tr>
        <tr><td>Địa chỉ:</td>
            <td><input type="text" id="txtAddress" name="txtAddress" maxlength="255" value="<%= h(reader.getAddress()) %>"></td></tr>
        <tr><td>Mã sinh viên / mã cán bộ (*):</td>
            <td><input type="text" id="txtReaderCode" name="txtReaderCode" maxlength="20" required pattern="[A-Za-z0-9]+"
                       title="Chỉ gồm chữ và số" value="<%= h(reader.getReaderCode()) %>" <%= codeLocked ? "readonly" : "" %>>
                <%= codeLocked ? "(đã đăng ký, không sửa được)" : "" %></td></tr>
        <tr><td>Lớp / đơn vị (*):</td>
            <td><input type="text" id="txtClassOrUnit" name="txtClassOrUnit" maxlength="100" required value="<%= h(reader.getClassOrUnit()) %>"></td></tr>
        <tr><td>Loại thẻ (*):</td>
            <td><select id="cbCardType" name="cbCardType" required>
                    <option value="">-- Chọn --</option>
                    <option <%= "Sinh viên".equals(cardType) ? "selected" : "" %>>Sinh viên</option>
                    <option <%= "Cán bộ".equals(cardType) ? "selected" : "" %>>Cán bộ</option>
                </select></td></tr>
        <tr><td>Thời hạn thẻ (*):</td>
            <td><select id="cbDuration" name="cbDuration" required>
                    <option value="">-- Chọn --</option>
                    <option value="6" <%= "6".equals(duration) ? "selected" : "" %>>6 tháng</option>
                    <option value="12" <%= "12".equals(duration) ? "selected" : "" %>>12 tháng</option>
                </select></td></tr>
        <tr><td></td>
            <td><input type="submit" id="btnAdd" value="Thêm"> <a id="btnBack" href="ReaderHomeView7.jsp">Quay lại</a></td></tr>
    </table>
</form>
<% } %>
</body>
</html>
