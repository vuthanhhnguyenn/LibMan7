-- =====================================================================
-- LibMan7 - Du lieu mau. Mat khau cua moi tai khoan: Libman@123
-- =====================================================================

-- Thanh vien (mat khau luu dang bam PBKDF2-SHA256)
INSERT INTO tblMember7(id, username, password, fullName, dateOfBirth, address, email, phone, role) VALUES
(1, 'binhtt', 'pbkdf2$65536$4Hfyty5Kmt+kEqND/BFVAQ==$4Sd7XEmBKD/Yk65s4gWSFlOXQgjG3odjruARnWjhp4g=', 'Trần Thị Bình', '1985-03-14', 'Cầu Giấy, Hà Nội', 'binhtt@ptit.edu.vn', '0983112233', 'staff'),
(2, 'lanht', 'pbkdf2$65536$+h+Kr5eLuA9R4793R2lQGQ==$yylPnN4uS58LZf7m1EjK5q6VJGJKfwyP0si7DWQp+88=', 'Hoàng Thị Lan', '1990-11-02', 'Thanh Xuân, Hà Nội', 'lanht@ptit.edu.vn', '0904556677', 'staff'),
(3, 'annv', 'pbkdf2$65536$0B25y1tXFpG8Q3nmC/BMYg==$W7OY3qFmUu9lzWD0KYFmcciCy593bNtKuhM/UAzyJVM=', 'Nguyễn Văn An', '2005-05-12', 'Hà Đông, Hà Nội', 'annv@stu.ptit.edu.vn', '0912345678', 'reader'),
(4, 'khoatm', 'pbkdf2$65536$GDH/tYCxdQBJmG4NUOnlKQ==$zH/WS54GB8IRJC07/dsDQw6FK5cnnAOPargOYKIXDkg=', 'Trần Minh Khoa', '2005-08-21', 'Nam Từ Liêm, Hà Nội', 'khoatm@stu.ptit.edu.vn', '0936221144', 'reader'),
(5, 'hatl', 'pbkdf2$65536$KNzOZMp1sNOYEyhUXMqjtQ==$LONWwTsjOm+fEw1n9p6XZ8GYGLSUTq6W3rARLdADBsg=', 'Lê Thu Hà', '2005-01-30', 'Hà Đông, Hà Nội', 'hatl@stu.ptit.edu.vn', '0977334455', 'reader'),
(6, 'ducpm', 'pbkdf2$65536$dfrYpK8x7lP0eG1Zg90rsQ==$ojxQB40ayTbdsJbHcuvKgz50hYS+XYHtUvaZk5KPx/A=', 'Phạm Minh Đức', '2004-07-09', 'Thanh Trì, Hà Nội', 'ducpm@stu.ptit.edu.vn', '0965778899', 'reader'),
(7, 'namvh', 'pbkdf2$65536$gywTPhWOJ2Gfwxa7sW7Znw==$nm8Ri+6S+tiq4HD0KDzF+wj07UveQpF5envkVJsW4YA=', 'Vũ Hải Nam', '2005-12-05', 'Hoàng Mai, Hà Nội', 'namvh@stu.ptit.edu.vn', '0941223344', 'reader'),
(8, 'lanmd', 'pbkdf2$65536$Pbjaz4a1k4gUlgA4YNw3Kg==$FnRMyt9zZp9c1pneQakVDzQzjHDIW3m7JxEcEGoAYks=', 'Đỗ Mai Lan', '2006-04-18', 'Long Biên, Hà Nội', 'lanmd@stu.ptit.edu.vn', '0388990011', 'reader'),
(9, 'huynq', 'pbkdf2$65536$IlgPV9iPvc0n9f9VPk4bAw==$OONmyt1QavUhPCFuHV5wC4xunt9QEJ4zhnDBLEMCiBI=', 'Ngô Quang Huy', '2005-09-27', 'Hà Đông, Hà Nội', 'huynq@stu.ptit.edu.vn', '0857112266', 'reader'),
(10, 'tambt', 'pbkdf2$65536$bUmue+7J6Cvf8YLx/M8/Ug==$CDIJEsOduNH03Bj47EQjHBa5pIChfABb/hRMzS6SIZ0=', 'Bùi Thanh Tâm', '2004-02-11', 'Đống Đa, Hà Nội', 'tambt@stu.ptit.edu.vn', '0702334488', 'reader'),
(11, 'hungnv', 'pbkdf2$65536$HzkOVqDFdThxc7ZJEuxwpQ==$ByipOEVvi+vVOkRPh1t9Y5Uhiz6PExL1BFMXfR6zxoY=', 'Nguyễn Việt Hùng', '2004-06-03', 'Hà Đông, Hà Nội', 'hungnv@stu.ptit.edu.vn', '0911667788', 'reader');

SELECT setval('tblmember7_id_seq', 11);

INSERT INTO tblStaff7(tblMember7id, staffCode, position) VALUES
(1, 'NV002', 'Nhân viên quản lý'),
(2, 'NV005', 'Nhân viên thư viện');

-- An (id 3) chua lam the lan nao nen chua co ma sinh vien va lop
INSERT INTO tblReader7(tblMember7id, readerCode, classOrUnit) VALUES
(3, NULL, NULL),
(4, 'B23DCCN112', 'D23CQCN04-B'),
(5, 'B23DCCN045', 'D23CQCN03-B'),
(6, 'B22DCAT110', 'D22CQAT02-B'),
(7, 'B23DCCN078', 'D23CQCN06-B'),
(8, 'B24DCKT012', 'D24CQKT01-B'),
(9, 'B23DCCN091', 'D23CQCN07-B'),
(10, 'B22DCCN204', 'D22CQCN04-B'),
(11, 'B22DCCN150', 'D22CQCN02-B');

-- The ban doc. The cua Hung da qua han nhung chua duoc chuyen sang 'Het han';
-- the cua Mai Lan bi khoa vi con giu tai lieu qua han.
INSERT INTO tblReaderCard7(cardCode, cardType, registerDate, expiryDate, status, tblReader7id) VALUES
('RC2025000350', 'Sinh viên', '2025-10-01', '2026-10-01', 'Còn hiệu lực', 11),
('RC2025000390', 'Sinh viên', '2025-10-20', '2026-10-20', 'Hết hạn', 6),
('RC2026000041', 'Sinh viên', '2026-01-10', '2027-01-10', 'Còn hiệu lực', 4),
('RC2026000087', 'Sinh viên', '2026-06-30', '2027-06-30', 'Còn hiệu lực', 5),
('RC2026000098', 'Sinh viên', '2026-07-05', '2027-07-05', 'Còn hiệu lực', 9),
('RC2026000102', 'Sinh viên', '2026-08-15', '2027-02-15', 'Còn hiệu lực', 7),
('RC2026000110', 'Sinh viên', '2026-08-20', '2027-08-20', 'Còn hiệu lực', 10),
('RC2026000120', 'Sinh viên', '2026-09-01', '2027-09-01', 'Bị khóa', 8);
SELECT setval('seqCardCode7', 152);   -- ma the tiep theo: RC<nam>000153

INSERT INTO tblDocument7(id, documentCode, title, documentType, author, publisher, publishYear, description) VALUES
(3,  'TL0003', 'Kỹ thuật lập trình C', 'Giáo trình', 'Phạm Văn Ất', 'NXB Giao thông vận tải', 2018, 'Giáo trình môn Kỹ thuật lập trình'),
(7,  'TL0007', 'Toán rời rạc', 'Giáo trình', 'Nguyễn Đức Nghĩa', 'NXB Đại học Quốc gia Hà Nội', 2009, 'Giáo trình môn Toán rời rạc'),
(12, 'TL0012', 'Giáo trình Cơ sở dữ liệu', 'Giáo trình', 'Nguyễn Kim Anh', 'NXB Đại học Quốc gia Hà Nội', 2004, 'Giáo trình môn Cơ sở dữ liệu'),
(20, 'TL0020', 'Mạng máy tính', 'Giáo trình', 'Hoàng Trọng Minh', 'Học viện Công nghệ Bưu chính Viễn thông', 2020, 'Bài giảng môn Mạng máy tính'),
(31, 'TL0031', 'Lập trình hướng đối tượng với Java', 'Sách', 'Trần Đình Quế', 'NXB Thông tin và Truyền thông', 2019, 'Sách tham khảo lập trình Java'),
(40, 'TL0040', 'Phân tích và thiết kế hệ thống thông tin', 'Giáo trình', 'Nguyễn Văn Ba', 'NXB Đại học Quốc gia Hà Nội', 2013, 'Giáo trình môn Phân tích thiết kế HTTT'),
(54, 'TL0054', 'Tạp chí Tin học và Đời sống số 9/2026', 'Tạp chí', 'Nhiều tác giả', 'Hội Tin học Việt Nam', 2026, 'Tạp chí định kỳ hằng tháng');
SELECT setval('tbldocument7_id_seq', 100);

INSERT INTO tblSupplier7(id, name, address, phone, email, description) VALUES
(1, 'Nhà sách Đại học Quốc gia', '16 Hàng Chuối, Hai Bà Trưng, Hà Nội', '02439712345', 'phathanh@nxbdhqghn.vn', 'Cung cấp giáo trình'),
(2, 'Công ty Phát hành sách Thông tin', '9 Nguyễn Du, Hà Nội', '02438221234', 'sach@ptsthongtin.vn', 'Cung cấp sách tham khảo'),
(3, 'Hội Tin học Việt Nam', '10 Đào Duy Anh, Đống Đa, Hà Nội', '02435771234', 'tapchi@vaip.org.vn', 'Cung cấp tạp chí');
SELECT setval('tblsupplier7_id_seq', 3);

INSERT INTO tblImportReceipt7(id, importDate, note, tblSupplier7id, tblStaff7id) VALUES
(1, '2025-08-12', 'Nhập giáo trình năm học 2025-2026', 1, 2),
(2, '2025-08-20', NULL, 2, 2),
(3, '2026-09-01', 'Tạp chí số tháng 9', 3, 2);
SELECT setval('tblimportreceipt7_id_seq', 3);

INSERT INTO tblImportLine7(id, quantity, unitPrice, tblImportReceipt7id, tblDocument7id) VALUES
(1, 4, 65000, 1, 12), (2, 5, 58000, 1, 7), (3, 2, 72000, 1, 20), (4, 2, 54000, 1, 3), (5, 3, 80000, 1, 40),
(6, 3, 125000, 2, 31),
(7, 2, 35000, 3, 54);
SELECT setval('tblimportline7_id_seq', 7);

INSERT INTO tblDocumentCopy7(barcode, location, status, tblDocument7id, tblImportLine7id) VALUES
('CSDL-0012-01', 'Kho A - Kệ 3', 'Sẵn sàng', 12, 1),
('CSDL-0012-02', 'Kho A - Kệ 3', 'Đang mượn', 12, 1),
('CSDL-0012-03', 'Kho A - Kệ 3', 'Sẵn sàng', 12, 1),
('CSDL-0012-04', 'Kho A - Kệ 3', 'Sẵn sàng', 12, 1),
('TRR-0007-01', 'Kho A - Kệ 1', 'Đang mượn', 7, 2),
('TRR-0007-02', 'Kho A - Kệ 1', 'Sẵn sàng', 7, 2),
('TRR-0007-03', 'Kho A - Kệ 1', 'Sẵn sàng', 7, 2),
('TRR-0007-04', 'Kho A - Kệ 1', 'Sẵn sàng', 7, 2),
('TRR-0007-05', 'Kho A - Kệ 1', 'Sẵn sàng', 7, 2),
('MMT-0020-01', 'Kho A - Kệ 5', 'Sẵn sàng', 20, 3),
('MMT-0020-02', 'Kho A - Kệ 5', 'Sẵn sàng', 20, 3),
('KTLT-0003-01', 'Kho A - Kệ 2', 'Sẵn sàng', 3, 4),
('KTLT-0003-02', 'Kho A - Kệ 2', 'Hỏng', 3, 4),
('PTTK-0040-01', 'Kho A - Kệ 6', 'Đang mượn', 40, 5),
('PTTK-0040-02', 'Kho A - Kệ 6', 'Sẵn sàng', 40, 5),
('PTTK-0040-03', 'Kho A - Kệ 6', 'Sẵn sàng', 40, 5),
('JAVA-0031-01', 'Kho B - Kệ 2', 'Sẵn sàng', 31, 6),
('JAVA-0031-02', 'Kho B - Kệ 2', 'Sẵn sàng', 31, 6),
('JAVA-0031-03', 'Kho B - Kệ 2', 'Sẵn sàng', 31, 6),
('TCTH-0054-01', 'Phòng đọc tạp chí', 'Sẵn sàng', 54, 7),
('TCTH-0054-02', 'Phòng đọc tạp chí', 'Sẵn sàng', 54, 7);

-- Phieu muon: tat ca do nhan vien thu vien Hoang Thi Lan (id 2) lap
INSERT INTO tblLoanReceipt7(id, loanDate, note, tblReader7id, tblStaff7id) VALUES
(398, '2026-08-20', NULL, 4, 2),
(405, '2026-08-28', NULL, 7, 2),
(412, '2026-09-02', NULL, 4, 2),
(415, '2026-09-03', NULL, 7, 2),
(418, '2026-09-04', NULL, 5, 2),
(421, '2026-09-05', NULL, 9, 2),
(425, '2026-09-07', NULL, 6, 2),
(429, '2026-09-10', NULL, 10, 2),
(433, '2026-09-10', NULL, 7, 2),
(436, '2026-09-11', NULL, 5, 2),
(440, '2026-09-14', NULL, 8, 2),
(444, '2026-09-16', NULL, 4, 2),
(447, '2026-09-18', NULL, 4, 2),
(450, '2026-09-21', NULL, 6, 2),
(452, '2026-09-22', NULL, 9, 2),
(456, '2026-09-24', NULL, 10, 2),
(459, '2026-09-27', NULL, 10, 2),
(466, '2026-10-15', NULL, 5, 2),
(471, '2026-11-05', NULL, 4, 2),
(473, '2026-11-06', 'Mượn để làm bài tập lớn', 7, 2);
SELECT setval('tblloanreceipt7_id_seq', 500);

INSERT INTO tblReturnReceipt7(id, returnDate, totalFine, tblStaff7id) VALUES
(101, '2026-08-30', 0, 2), (102, '2026-09-05', 0, 2), (103, '2026-09-09', 5000, 2),
(104, '2026-09-15', 0, 2), (105, '2026-09-13', 0, 2), (106, '2026-09-18', 0, 2),
(107, '2026-09-19', 0, 2), (108, '2026-09-20', 0, 2), (109, '2026-09-20', 0, 2),
(110, '2026-09-23', 0, 2), (111, '2026-09-29', 0, 2), (112, '2026-09-30', 0, 2),
(113, '2026-10-03', 0, 2), (114, '2026-10-08', 4000, 2), (115, '2026-10-07', 0, 2),
(116, '2026-10-10', 0, 2), (117, '2026-10-28', 0, 2);
SELECT setval('tblreturnreceipt7_id_seq', 200);

-- Dong muon: moi dong la mot ban sao trong mot phieu muon
INSERT INTO tblLoanLine7(dueDate, returnCondition, fine, status, tblLoanReceipt7id, tblDocumentCopy7id, tblReturnReceipt7id)
SELECT v.dueDate::date, v.cond, v.fine, v.status, v.rid, c.id, v.rr
FROM (VALUES
 ('2026-09-03', 'Nguyên vẹn', 0, 'Đã trả', 398, 'MMT-0020-01', 101),
 ('2026-09-11', 'Nguyên vẹn', 0, 'Đã trả', 405, 'TRR-0007-02', 102),
 ('2026-09-16', 'Nguyên vẹn', 0, 'Đã trả', 412, 'CSDL-0012-01', 103),
 ('2026-09-16', 'Nguyên vẹn', 0, 'Đã trả', 412, 'JAVA-0031-02', 103),
 ('2026-09-16', 'Rách bìa', 5000, 'Đã trả', 412, 'TRR-0007-05', 103),
 ('2026-09-17', 'Nguyên vẹn', 0, 'Đã trả', 415, 'JAVA-0031-01', 104),
 ('2026-09-18', 'Nguyên vẹn', 0, 'Đã trả', 418, 'CSDL-0012-02', 105),
 ('2026-09-18', 'Nguyên vẹn', 0, 'Đã trả', 418, 'TRR-0007-01', 105),
 ('2026-09-19', 'Nguyên vẹn', 0, 'Đã trả', 421, 'JAVA-0031-03', 106),
 ('2026-09-19', 'Nguyên vẹn', 0, 'Đã trả', 421, 'TCTH-0054-01', 106),
 ('2026-09-21', 'Nguyên vẹn', 0, 'Đã trả', 425, 'CSDL-0012-03', 107),
 ('2026-09-21', 'Nguyên vẹn', 0, 'Đã trả', 425, 'MMT-0020-01', 107),
 ('2026-09-24', 'Nguyên vẹn', 0, 'Đã trả', 429, 'JAVA-0031-02', 108),
 ('2026-09-24', 'Nguyên vẹn', 0, 'Đã trả', 433, 'CSDL-0012-01', 109),
 ('2026-09-24', 'Nguyên vẹn', 0, 'Đã trả', 433, 'TCTH-0054-02', 109),
 ('2026-09-25', 'Nguyên vẹn', 0, 'Đã trả', 436, 'TRR-0007-02', 110),
 ('2026-09-28', NULL, 0, 'Quá hạn', 440, 'CSDL-0012-02', NULL),
 ('2026-09-30', 'Nguyên vẹn', 0, 'Đã trả', 444, 'JAVA-0031-01', 111),
 ('2026-09-30', 'Nguyên vẹn', 0, 'Đã trả', 444, 'MMT-0020-02', 111),
 ('2026-10-02', 'Nguyên vẹn', 0, 'Đã trả', 447, 'CSDL-0012-04', 112),
 ('2026-10-05', 'Nguyên vẹn', 0, 'Đã trả', 450, 'TRR-0007-03', 113),
 ('2026-10-05', 'Nguyên vẹn', 0, 'Đã trả', 450, 'TCTH-0054-01', 113),
 ('2026-10-06', 'Nguyên vẹn, trả trễ 2 ngày', 4000, 'Đã trả', 452, 'CSDL-0012-03', 114),
 ('2026-10-08', 'Nguyên vẹn', 0, 'Đã trả', 456, 'JAVA-0031-03', 115),
 ('2026-10-11', 'Nguyên vẹn', 0, 'Đã trả', 459, 'CSDL-0012-01', 116),
 ('2026-10-11', 'Nguyên vẹn', 0, 'Đã trả', 459, 'TRR-0007-04', 116),
 ('2026-10-29', 'Nguyên vẹn', 0, 'Đã trả', 466, 'CSDL-0012-04', 117),
 ('2026-11-19', NULL, 0, 'Đang mượn', 471, 'TRR-0007-01', NULL),
 ('2026-11-20', NULL, 0, 'Đang mượn', 473, 'PTTK-0040-01', NULL)
) AS v(dueDate, cond, fine, status, rid, barcode, rr)
JOIN tblDocumentCopy7 c ON c.barcode = v.barcode
ORDER BY v.rid, v.barcode;
