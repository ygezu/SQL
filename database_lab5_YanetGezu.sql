--1
CREATE PROCEDURE ygezuSelectInvoiceCount
AS
BEGIN
    SELECT 
        CONCAT(c.LAST_NAME, ', ', c.FIRST_NAME) AS 'CustomerName',
        COUNT(i.INVOICE_NUM) AS 'InvoiceCount'
    FROM 
        CUSTOMER c
    LEFT JOIN 
        INVOICES i ON c.CUST_ID = i.CUST_ID
    GROUP BY 
        CONCAT(c.LAST_NAME, ', ', c.FIRST_NAME)
    ORDER BY 
        CustomerName;
END;
GO


--2
CREATE PROCEDURE ygezuGetInvoiceDetailsForCustomer
    @Cust_ID INT
AS
BEGIN
    SELECT
        YEAR(i.INVOICE _DATE) AS InvoiceYear,
        MONTH(i.INVOICE_DATE) AS InvoiceMonth,
        i.INVOICE_NUM,
        il.ITEMID,
        UPPER(il.Itemdescription) AS UpperCaseItemDescription,
        il.quantityordered,
        il.QuotedPrice
    FROM
        INVOICES
        JOIN i.INVOICE_ITEM il ON i.InvoiceID = il.InvoiceID
    WHERE
          Cust_ID = @Cust_ID;
END;

--3
CREATE PROCEDURE ygezu_DeleteCustomer
    @CustomerID INT
AS

    DELETE FROM CUSTOMER
    WHERE CUST_ID = @CustomerID;
GO

--4
CREATE PROCEDURE ygezu_InsertInvoice
    @InvoiceNumber INT,
    @InvoiceDate DATE,
    @CustomerID INT
AS
BEGIN
    IF @InvoiceDate >= GETDATE() AND NOT EXISTS (SELECT 1 FROM INVOICES WHERE INVOICE_NUM = @InvoiceNumber)
    BEGIN
        INSERT INTO INVOICES (INVOICE_NUM, INVOICE_DATE, CUST_ID)
        VALUES (@InvoiceNumber, @InvoiceDate, @CustomerID);
    END;
END;
GO

--5
CREATE PROCEDURE ygezu_InsertCustomer
    @CustomerID INT,
    @FirstName VARCHAR(20),
    @LastName VARCHAR(20),
    @Address VARCHAR(20),
    @City VARCHAR(15),
    @State CHAR(2),
    @Postal INT,
    @Email VARCHAR(100),
    @Balance DECIMAL(7,2),
    @CreditLimit DECIMAL(7,2),
    @RepID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE EMAIL = @Email) 
       AND EXISTS (SELECT 1 FROM SALES_REP WHERE REP_ID = @RepID)
    BEGIN
        INSERT INTO CUSTOMER (CUST_ID, FIRST_NAME, LAST_NAME, ADDRESS, CITY, STATE, POSTAL, EMAIL, BALANCE, CREDIT_LIMIT, REP_ID)
        VALUES (@CustomerID, @FirstName, @LastName, @Address, @City, @State, @Postal, @Email, @Balance, @CreditLimit, @RepID);
    END;
END;
GO

--6
CREATE PROCEDURE ygezu_UpdateCustomer
    @CustomerID INT,
    @FirstName VARCHAR(20),
    @LastName VARCHAR(20),
    @Address VARCHAR(20),
    @City VARCHAR(15),
    @State CHAR(2),
    @Postal INT,
    @Email VARCHAR(100),
    @Balance DECIMAL(7,2),
    @CreditLimit DECIMAL(7,2),
    @RepID INT
AS
BEGIN
    UPDATE CUSTOMER
    SET FIRST_NAME = @FirstName,
        LAST_NAME = @LastName,
        ADDRESS = @Address,
        CITY = @City,
        STATE = @State,
        POSTAL = @Postal,
        EMAIL = @Email,
        BALANCE = @Balance,
        CREDIT_LIMIT = @CreditLimit,
        REP_ID = @RepID
    WHERE CUST_ID = @CustomerID;
END;
GO

--7
CREATE PROCEDURE ygezu_UpdateCreditLimit
    @CustomerID INT,
    @NewCreditLimit DECIMAL(7,2)
AS
BEGIN
    DECLARE @OldCreditLimit DECIMAL(7,2)

    SELECT @OldCreditLimit = CREDIT_LIMIT
    FROM CUSTOMER
    WHERE CUST_ID = @CustomerID

    IF @NewCreditLimit > 0 AND @NewCreditLimit < 10000
    BEGIN
        UPDATE CUSTOMER
        SET CREDIT_LIMIT = @NewCreditLimit
        WHERE CUST_ID = @CustomerID
    END
END;
GO
--8
CREATE PROCEDURE ygezuInsertItem
(
    @ItemID CHAR(4),
    @Description VARCHAR(255),
    @OnHand INT,
    @Category VARCHAR(3),
    @Location CHAR(1) = 'A',
    @Price DECIMAL(7,2)
)
AS
BEGIN
    IF ((@Location = 'A' AND @OnHand BETWEEN 1 AND 25)
        OR (@Location = 'B' AND @OnHand BETWEEN 1 AND 10)
        OR (@Location = 'C' AND @OnHand BETWEEN 1 AND 50)
        OR (@Location NOT IN ('A', 'B', 'C') AND @OnHand BETWEEN 1 AND 20))
    BEGIN
        INSERT INTO dbo.ITEM (ITEM_ID, [DESCRIPTION], ON_HAND, CATEGORY, [LOCATION], PRICE)
        VALUES (@ItemID, @Description, @OnHand, @Category, @Location, @Price);

    END;
END;
GO

