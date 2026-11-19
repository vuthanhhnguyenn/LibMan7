-- =====================================================================
-- LibMan7 - He thong quan ly thu vien (De 4, B23DCCN617)
-- Script tao CSDL PostgreSQL. Chay tren CSDL rong "libman7":
--   psql -U postgres -c "CREATE DATABASE libman7 ENCODING 'UTF8'"
--   psql -U postgres -d libman7 -f sql/01_schema.sql
--   psql -U postgres -d libman7 -f sql/02_data.sql
-- =====================================================================

DROP TABLE IF EXISTS tblLoanLine7, tblReturnReceipt7, tblLoanReceipt7, tblDocumentCopy7,
    tblImportLine7, tblImportReceipt7, tblSupplier7, tblDocument7, tblReaderCard7,
    tblReader7, tblStaff7, tblMember7 CASCADE;
DROP SEQUENCE IF EXISTS seqCardCode7;

-- Thanh vien: phan chung cua nhan vien va ban doc
CREATE TABLE tblMember7 (
    id          SERIAL PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,            -- PBKDF2: pbkdf2$vong$muoi$bam
    fullName    VARCHAR(100) NOT NULL,
    dateOfBirth DATE,
    address     VARCHAR(255),
    email       VARCHAR(100),
    phone       VARCHAR(20),
    role        VARCHAR(20)  NOT NULL CHECK (role IN ('reader', 'staff'))
);

-- Nhan vien: position phan biet nhan vien quan ly va nhan vien thu vien
CREATE TABLE tblStaff7 (
    tblMember7id INTEGER PRIMARY KEY REFERENCES tblMember7(id),
    staffCode    VARCHAR(20) NOT NULL UNIQUE,
    position     VARCHAR(50) NOT NULL
                 CHECK (position IN ('Nhân viên quản lý', 'Nhân viên thư viện'))
);

-- Ban doc: readerCode de trong cho toi khi lam the lan dau
CREATE TABLE tblReader7 (
    tblMember7id INTEGER PRIMARY KEY REFERENCES tblMember7(id),
    readerCode   VARCHAR(20) UNIQUE,
    classOrUnit  VARCHAR(100)
);

CREATE TABLE tblReaderCard7 (
    id           SERIAL PRIMARY KEY,
    cardCode     VARCHAR(20) NOT NULL UNIQUE,
    cardType     VARCHAR(50) NOT NULL CHECK (cardType IN ('Sinh viên', 'Cán bộ')),
    registerDate DATE        NOT NULL,
    expiryDate   DATE        NOT NULL,
    status       VARCHAR(20) NOT NULL CHECK (status IN ('Còn hiệu lực', 'Bị khóa', 'Hết hạn')),
    tblReader7id INTEGER     NOT NULL REFERENCES tblReader7(tblMember7id),
    CHECK (expiryDate > registerDate)
);
-- Moi ban doc co nhieu nhat mot the chua het han (chan ca hai yeu cau gui cung luc)
CREATE UNIQUE INDEX uqActiveCard7 ON tblReaderCard7(tblReader7id) WHERE status <> 'Hết hạn';
-- So thu tu de sinh ma the RC + nam + 6 chu so
CREATE SEQUENCE seqCardCode7 START 1;

CREATE TABLE tblDocument7 (
    id           SERIAL PRIMARY KEY,
    documentCode VARCHAR(20)  NOT NULL UNIQUE,
    title        VARCHAR(255) NOT NULL,
    documentType VARCHAR(50)  NOT NULL,
    author       VARCHAR(255),
    publisher    VARCHAR(255),
    publishYear  INTEGER,
    description  VARCHAR(500)
);

CREATE TABLE tblSupplier7 (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    address     VARCHAR(255),
    phone       VARCHAR(20),
    email       VARCHAR(100),
    description VARCHAR(500)
);

CREATE TABLE tblImportReceipt7 (
    id             SERIAL PRIMARY KEY,
    importDate     DATE    NOT NULL,
    note           VARCHAR(500),
    tblSupplier7id INTEGER NOT NULL REFERENCES tblSupplier7(id),
    tblStaff7id    INTEGER NOT NULL REFERENCES tblStaff7(tblMember7id)
);

CREATE TABLE tblImportLine7 (
    id                  SERIAL PRIMARY KEY,
    quantity            INTEGER       NOT NULL CHECK (quantity > 0),
    unitPrice           NUMERIC(12,2) NOT NULL CHECK (unitPrice >= 0),
    tblImportReceipt7id INTEGER       NOT NULL REFERENCES tblImportReceipt7(id),
    tblDocument7id      INTEGER       NOT NULL REFERENCES tblDocument7(id)
);

CREATE TABLE tblDocumentCopy7 (
    id               SERIAL PRIMARY KEY,
    barcode          VARCHAR(50)  NOT NULL UNIQUE,
    location         VARCHAR(100),
    status           VARCHAR(20)  NOT NULL CHECK (status IN ('Sẵn sàng', 'Đang mượn', 'Hỏng', 'Mất')),
    tblDocument7id   INTEGER      NOT NULL REFERENCES tblDocument7(id),
    tblImportLine7id INTEGER      REFERENCES tblImportLine7(id)
);

CREATE TABLE tblLoanReceipt7 (
    id           SERIAL PRIMARY KEY,
    loanDate     DATE    NOT NULL,
    note         VARCHAR(500),
    tblReader7id INTEGER NOT NULL REFERENCES tblReader7(tblMember7id),
    tblStaff7id  INTEGER NOT NULL REFERENCES tblStaff7(tblMember7id)
);

CREATE TABLE tblReturnReceipt7 (
    id          SERIAL PRIMARY KEY,
    returnDate  DATE          NOT NULL,
    totalFine   NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (totalFine >= 0),
    tblStaff7id INTEGER       NOT NULL REFERENCES tblStaff7(tblMember7id)
);

CREATE TABLE tblLoanLine7 (
    id                  SERIAL PRIMARY KEY,
    dueDate             DATE          NOT NULL,
    returnCondition     VARCHAR(100),
    fine                NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (fine >= 0),
    status              VARCHAR(20)   NOT NULL CHECK (status IN ('Đang mượn', 'Quá hạn', 'Đã trả')),
    tblLoanReceipt7id   INTEGER       NOT NULL REFERENCES tblLoanReceipt7(id),
    tblDocumentCopy7id  INTEGER       NOT NULL REFERENCES tblDocumentCopy7(id),
    tblReturnReceipt7id INTEGER       REFERENCES tblReturnReceipt7(id)   -- trong khi chua tra
);

-- Chi muc cho truy van thong ke theo khoang ngay
CREATE INDEX idxLoanDate7      ON tblLoanReceipt7(loanDate);
CREATE INDEX idxLoanLineRec7   ON tblLoanLine7(tblLoanReceipt7id);
CREATE INDEX idxLoanLineCopy7  ON tblLoanLine7(tblDocumentCopy7id);
CREATE INDEX idxCopyDocument7  ON tblDocumentCopy7(tblDocument7id);
CREATE INDEX idxCardReader7    ON tblReaderCard7(tblReader7id);
