<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jspf/common7.jspf" %>
<%
    Reader7 reader = (Reader7) session.getAttribute("reader");
    if (reader == null) {
        // phiên hết hạn trước khi bấm Thêm: không lưu gì
        response.sendRedirect(loginRedirect(request.getContextPath(), session));
        return;
    }
    String message;                    // nội dung thông báo
    String okLink = "ReaderHomeView7.jsp";

    if (!"POST".equals(request.getMethod())) {
        // GET ?done=1 sau khi lưu thành công (bấm F5 không gửi lại form)
        ReaderCard7 newCard = (ReaderCard7) session.getAttribute("newCard");
        if (newCard == null) {
            response.sendRedirect("RegisterCardView7.jsp");
            return;
        }
        session.removeAttribute("newCard");
        message = "Đăng ký làm thẻ bạn đọc thành công.<br>Mã thẻ: <b>" + h(newCard.getCardCode()) + "</b><br>"
                + "Loại thẻ: " + h(newCard.getCardType()) + "<br>Ngày đăng ký: " + d(newCard.getRegisterDate())
                + "<br>Hạn sử dụng: " + d(newCard.getExpiryDate());
    } else {
        // 1. Lấy dữ liệu form, kiểm tra lại phía server
        String fullName = request.getParameter("txtFullName").trim();
        Date dob = parseIso(request.getParameter("txtDateOfBirth"));
        String email = request.getParameter("txtEmail").trim().toLowerCase();
        String phone = request.getParameter("txtPhone").trim();
        String address = request.getParameter("txtAddress").trim();
        String readerCode = request.getParameter("txtReaderCode").trim().toUpperCase();
        String classOrUnit = request.getParameter("txtClassOrUnit").trim();
        String cardType = request.getParameter("cbCardType");
        String duration = request.getParameter("cbDuration");
        if (Boolean.TRUE.equals(session.getAttribute("codeLocked"))) {
            readerCode = reader.getReaderCode();   // mã đã đăng ký thì giữ nguyên
        }
        Date today = today();

        String errors = "";
        if (fullName.isEmpty()) errors += "Họ và tên không được trống.<br>";
        if (dob == null || !dob.before(today)) errors += "Ngày sinh phải trước ngày hiện tại.<br>";
        if (!email.matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+")) errors += "Email không đúng định dạng.<br>";
        if (!phone.matches("0[0-9]{9}")) errors += "Số điện thoại phải gồm 10 chữ số, bắt đầu bằng số 0.<br>";
        if (!readerCode.matches("[A-Z0-9]{1,20}")) errors += "Mã sinh viên / mã cán bộ chỉ gồm chữ và số.<br>";
        if (classOrUnit.isEmpty()) errors += "Lớp / đơn vị không được trống.<br>";
        if (!"Sinh viên".equals(cardType) && !"Cán bộ".equals(cardType)) errors += "Chưa chọn loại thẻ.<br>";
        if (!"6".equals(duration) && !"12".equals(duration)) errors += "Chưa chọn thời hạn thẻ.<br>";

        // Ghi lại dữ liệu vừa nhập vào reader trong session để hiện lại form nếu có lỗi
        reader.setFullName(fullName);
        if (dob != null) reader.setDateOfBirth(dob);
        reader.setEmail(email);
        reader.setPhone(phone);
        reader.setAddress(address.isEmpty() ? null : address);
        reader.setReaderCode(readerCode);
        reader.setClassOrUnit(classOrUnit);
        session.setAttribute("formCardType", cardType == null ? "" : cardType);
        session.setAttribute("formDuration", duration == null ? "" : duration);

        if (!errors.isEmpty()) {
            message = "Dữ liệu chưa hợp lệ:<br>" + errors;
            okLink = "RegisterCardView7.jsp?keep=1";
        } else {
            // 2. Tạo thẻ: ngày đăng ký là hôm nay, hạn = ngày đăng ký + thời hạn
            ReaderCard7 card = new ReaderCard7();
            card.setCardType(cardType);
            card.setRegisterDate(today);
            Calendar cal = Calendar.getInstance();
            cal.setTime(today);
            cal.add(Calendar.MONTH, Integer.parseInt(duration));
            card.setExpiryDate(cal.getTime());
            card.setReader(reader);

            // 3. Gọi DAO lưu thẻ
            boolean result = false;
            ReaderCard7 nowActive = null;
            ReaderCardDAO7 dao = null;
            try {
                dao = new ReaderCardDAO7();
                result = dao.addCard(card);
                if (!result) nowActive = dao.getActiveCard(reader.getId());   // vừa đăng ký ở tab khác?
            } catch (RuntimeException e) {
                result = false;
            } finally {
                if (dao != null) dao.close();
            }

            if (result) {
                session.setAttribute("newCard", card);
                session.setAttribute("codeLocked", true);
                response.sendRedirect("doRegisterCard7.jsp?done=1");
                return;
            }
            if (nowActive != null) {
                message = "Bạn đã có thẻ chưa hết hạn (mã " + h(nowActive.getCardCode()) + ", hạn "
                        + d(nowActive.getExpiryDate()) + "), không thể đăng ký thêm.";
            } else {
                message = "Đăng ký làm thẻ không thành công, vui lòng kiểm tra lại mã sinh viên hoặc thử lại sau.";
                okLink = "RegisterCardView7.jsp?keep=1";
            }
        }
    }
%>
<html>
<head><title>LibMan - Thông báo</title></head>
<body>
<h2>Thông báo</h2>
<p><%= message %></p>
<a href="<%= okLink %>">OK</a>
</body>
</html>
