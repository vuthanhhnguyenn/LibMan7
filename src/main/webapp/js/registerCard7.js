// Kiểm tra form đăng ký làm thẻ trên trình duyệt. Trang doRegisterCard7.jsp kiểm tra lại phía server.
(function () {
    var form = document.getElementById('frmRegisterCard');
    if (!form) return;

    var rules = [
        ['txtFullName', function (v) { return v.trim() ? '' : 'Vui lòng nhập họ và tên'; }],
        ['txtDateOfBirth', function (v) {
            if (!v) return 'Vui lòng chọn ngày sinh';
            var today = new Date(); today.setHours(0, 0, 0, 0);
            return new Date(v + 'T00:00:00') < today ? '' : 'Ngày sinh phải trước ngày hiện tại';
        }],
        ['txtEmail', function (v) {
            if (!v.trim()) return 'Vui lòng nhập email';
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim()) ? '' : 'Email không đúng định dạng, ví dụ: ten@stu.ptit.edu.vn';
        }],
        ['txtPhone', function (v) {
            return /^0[0-9]{9}$/.test(v.trim()) ? '' : 'Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0';
        }],
        ['txtReaderCode', function (v) {
            if (!v.trim()) return 'Vui lòng nhập mã sinh viên / mã cán bộ';
            return /^[A-Za-z0-9]{1,20}$/.test(v.trim()) ? '' : 'Mã chỉ gồm chữ và số, không quá 20 ký tự';
        }],
        ['txtClassOrUnit', function (v) { return v.trim() ? '' : 'Vui lòng nhập lớp / đơn vị'; }],
        ['cbCardType', function (v) { return v ? '' : 'Vui lòng chọn loại thẻ'; }],
        ['cbDuration', function (v) { return v ? '' : 'Vui lòng chọn thời hạn thẻ'; }]
    ];

    form.addEventListener('submit', function (ev) {
        var bad = 0;
        rules.forEach(function (r) {
            var input = document.getElementById(r[0]);
            var msg = r[1](input.value);
            var box = document.getElementById('err_' + r[0]);
            box.textContent = msg;
            input.classList.toggle('bad', !!msg);
            if (msg) bad++;
        });
        var top = document.getElementById('errTop');
        if (bad > 0) {
            ev.preventDefault();
            top.textContent = 'Có ' + bad + ' ô nhập chưa đúng, vui lòng sửa lại trước khi bấm Thêm.';
            return;
        }
        top.textContent = '';
        // Khóa nút Thêm để không gửi form hai lần
        var btn = document.getElementById('btnAdd');
        btn.disabled = true;
        btn.value = 'Đang gửi...';
    });

    // Quay lại trang này bằng nút Back của trình duyệt thì mở lại nút Thêm
    window.addEventListener('pageshow', function () {
        var btn = document.getElementById('btnAdd');
        if (btn) { btn.disabled = false; btn.value = 'Thêm'; }
    });
})();
