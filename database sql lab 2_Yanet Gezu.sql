
--1. For each invoice, list the invoice number and invoice date along with the ID, first name, and last name of the customer for which the invoice was created.
SELECT INVOICE_NUM, INVOICE_DATE, CUSTOMER.CUST_ID, FIRST_NAME, LAST_NAME
FROM INVOICES, CUSTOMER
WHERE INVOICES.CUST_ID = CUSTOMER.CUST_ID;
--2. For each invoice placed on November 15, 2021, list the invoice number along with the ID, first name, and last name of the customer for which the invoice was created.
SELECT INVOICES.INVOICE_NUM, CUSTOMER.CUST_ID, FIRST_NAME, LAST_NAME
FROM INVOICES
INNER JOIN CUSTOMER ON INVOICES.CUST_ID = CUSTOMER.CUST_ID
WHERE INVOICE_DATE = '2021-11-15';
--3. For each invoice, list the invoice number, invoice date, item ID, quantity ordered, and quoted price for each invoice line that makes up the invoice.
SELECT INVOICES.INVOICE_NUM, INVOICE_DATE, ITEM_ID, QUANTITY, QUOTED_PRICE
FROM INVOICES, INVOICE_LINE
WHERE (INVOICES.INVOICE_NUM = INVOICE_LINE.INVOICE_NUM);
--4. Use the IN operator to find the ID, first name, and last name of each customer for which an invoice was created on November 15, 2021.
SELECT CUST_ID, FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUST_ID IN (SELECT CUST_ID FROM INVOICES WHERE INVOICE_DATE = '2021-11-15');

--5. Find the ID, first name, and last name of each customer for which an invoice was not created on November 15, 2021.
SELECT CUST_ID, FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUST_ID IN (SELECT CUST_ID FROM INVOICES WHERE INVOICE_DATE <> '2021-11-15');
--6. For each invoice, list the invoice number, invoice date, item ID, description, and category for each item that makes up the invoice.
SELECT INVOICES.INVOICE_NUM, INVOICE_DATE, ITEM.ITEM_ID, DESCRIPTION, CATEGORY
FROM INVOICES, INVOICE_LINE, ITEM
WHERE (INVOICES.INVOICE_NUM = INVOICE_LINE.INVOICE_NUM)
AND (INVOICE_LINE.ITEM_ID = ITEM.ITEM_ID);
--7. Find the ID, first name, and last name of each customer that currently has an invoice on file for Wild Bird Food (25 lb).
SELECT CUST_ID, FIRST_NAME, LAST_NAME
FROM CUSTOMER
WHERE CUST_ID IN (SELECT CUST_ID
FROM INVOICES
WHERE INVOICE_NUM IN (SELECT INVOICE_NUM
FROM INVOICE_LINE
WHERE ITEM_ID = 'KH81'));
--8. List the item ID, description, and category for each pair of items that are in the same category. (For example, one such pair would be item FS42 and item PF19, because the category for both items is FSH.)
SELECT F.CATEGORY, F.ITEM_ID, F.DESCRIPTION
FROM ITEM F, ITEM S
WHERE F.CATEGORY = S.CATEGORY
AND F.ITEM_ID <> S.ITEM_ID
AND S.CATEGORY IN ('BRD', 'CAT', 'FSH')
ORDER BY F.CATEGORY;

--9. List the invoice number and invoice date for each invoice created for the customer James Gonzalez.
SELECT INVOICE_NUM, INVOICE_DATE
FROM INVOICES
WHERE CUST_ID IN (SELECT CUST_ID
FROM CUSTOMER
WHERE FIRST_NAME = 'James'
AND LAST_NAME = 'Gonzalez');
--10. List the invoice number and invoice date for each invoice that contains an invoice line for Wild Bird Food (25 lb).
SELECT I.INVOICE_NUM, I.INVOICE_DATE
FROM INVOICES I
INNER JOIN INVOICE_LINE L
ON I.INVOICE_NUM = L.INVOICE_NUM
INNER JOIN ITEM T
ON L.ITEM_ID = T.ITEM_ID
WHERE T.DESCRIPTION = 'Wild Bird Food (25 lb)';
--11. List the invoice number and invoice date for each invoice that either was created for James Gonzalez or that contains an invoice line for Wild Bird Food (25 lb).
SELECT I.INVOICE_NUM, I.INVOICE_DATE
FROM INVOICES I
INNER JOIN CUSTOMER C
ON I.CUST_ID = C.CUST_ID
INNER JOIN INVOICE_LINE L
ON I.INVOICE_NUM = L.INVOICE_NUM
INNER JOIN ITEM T
ON L.ITEM_ID = T.ITEM_ID
WHERE T.DESCRIPTION = 'Wild Bird Food (25 lb)'
OR (C.FIRST_NAME = 'James' AND C.LAST_NAME = 'Gonzalez');
--12. List the invoice number and invoice date for each invoice that was created for James Gonzalez and that contains an invoice line for Wild Bird Food (25 lb).
SELECT I.INVOICE_NUM, I.INVOICE_DATE
FROM INVOICES I
INNER JOIN CUSTOMER C
ON I.CUST_ID = C.CUST_ID
INNER JOIN INVOICE_LINE L
ON I.INVOICE_NUM = L.INVOICE_NUM
INNER JOIN ITEM T
ON L.ITEM_ID = T.ITEM_ID
WHERE T.DESCRIPTION = 'Wild Bird Food (25 lb)'
AND (C.FIRST_NAME = 'James' AND C.LAST_NAME = 'Gonzalez');
--13. List the item ID, description, unit price, and category for each item that has a unit price greater than the unit price of every item in category CAT. Use either the ALL or ANY operator in your query.
SELECT ITEM_ID, DESCRIPTION, PRICE, CATEGORY
FROM ITEM
WHERE (PRICE > ALL (SELECT PRICE
FROM ITEM
WHERE (CATEGORY = 'CAT')));
  