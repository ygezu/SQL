--1.	List the item ID, description, and price for all items.
select ITEM_ID, description, price
from dbo.ITEM;

--2.	List all rows and columns for the complete INVOICES table.
select*
from dbo.invoices;

--3.	List the first and last names of customers with credit limits of $1,000 or more.
select first_name, last_name
from dbo.customer
where credit_limit >= 1000;

--4.	List the order number for each order placed by customer number 125 on 11/15/2021. (Hint: If you need help, use the discussion of the DATE data type in Figure 3-19 in Module 3.)
select invoice_num
from dbo.invoices
where cust_id = 125
AND invoice_date = '2021-11-15';

--5.	List the number and name of each customer represented by sales rep 10 or sales rep 15.
select CUST_ID, FIRST_NAME
FROM dbo.customer
where REP_ID IN (10, 15);

--6.	List the item ID and description of each item that is not in category HOR.
SELECT ITEM_ID, DESCRIPTION
fROM dbo.ITEM
whERE CATEGORY <> 'HOR';


--7.	List the item ID, description, and number of units on hand for each item that has between 10 and 30 units on hand, including both 10 and 30. Provide two alternate SQL statements to produce the same results.
select item_id, description, on_hand
from dbo.item
Where on_hand between 10 AND 30 

select item_id, description, on_hand
from dbo.item
where on_hand >= 10 AND on_hand<=30

--8.	List the item ID, description, and on-hand value (units on hand * unit price) of each item in category CAT. (On-hand value is technically units on hand * cost, but there is no COST column in the ITEM table.) Assign the name ON_HAND_VALUE to the computed column.
select item_id, description, on_hand AS ON_HAND_VALUE
FROM dbo.item
Where CATEGORY= 'CAT' 


--9.	List the item ID, description, and on-hand value for each item where the on-hand value is at least $1,500. Assign the name ON_HAND_VALUE to the computed column.
SELECT ITEM_ID, DESCRIPTION, ON_HAND * PRICE AS ON_HAND_VALUE
FROM dbo.item
WHERE (ON_HAND * PRICE) >= 1500;


--10.	Use the IN operator to list the item ID and description of each item in category FSH or BRD.
SELECT ITEM_ID, DESCRIPTION
from dbo.item
where CATEGORY IN ('FSH', 'BRD')

--11.	Find the ID, first name, and last name of each customer whose first name begins with the letter “S.”
select cust_id, first_name, last_name
from dbo.customer
where first_name LIKE 'S%';

--12.	List all details about all items. Order the output by description.
select *
from dbo.item
order by description;

--13.	List all details about all items. Order the output by item ID within location. (That is, order the output by location and then by item ID.)
select *
from dbo.item
order by location, item_id;

--14.	How many customers have balances that are more than their credit limits?
select count(*)
from dbo.customer
where balance > CREDIT_LIMIT;

--15.	Find the total of the balances for all customers represented by sales rep 10 with balances that are less than their credit limits.
select sum(balance)
from dbo.customer
where rep_id = 10 AND balance< credit_limit;

--16.	List the item ID, description, and on-hand value of each item whose number of units on hand is more than the average number of units on hand for all items. (Hint: Use a subquery.)
select item_id, description, on_hand * price AS ON_HAND_VALUE
from dbo.item
where on_hand > (select AVG(on_hand) from dbo.item);

--17.	What is the price of the least expensive item in the database?
select min(price) 
from dbo.item;

--18.	What is the item ID, description, and price of the least expensive item in the database? (Hint: Use a subquery.)
select item_id, description, price
from dbo.item
where price = (select min(price) from dbo.item);

--19.	List the sum of the balances of all customers for each sales rep. Order and group the results by sales rep ID.
select REP_ID, SUM(BALANCE)
FROM dbo.customer
group by REP_ID;

--20.	List the sum of the balances of all customers for each sales rep but restrict the output to those sales reps for which the sum is more than $150. Order the results by sales rep ID.
SELECT REP_ID, SUM(BALANCE)
FROM dbo.CUSTOMER
GROUP BY REP_ID
HAVING SUM(BALANCE) > 150
ORDER BY REP_ID;

--21.	List the item ID of any item with an unknown description.
SELECT ITEM_ID
FROM dbo.ITEM
WHERE DESCRIPTION IS NULL;

--22.	List the item ID and description of all items that are in the DOG or CAT category and contain the word “Small” in the description.
SELECT ITEM_ID, DESCRIPTION
FROM dbo.ITEM
WHERE (CATEGORY = 'DOG' OR CATEGORY = 'CAT') AND DESCRIPTION LIKE '%Small%';

--23.	KimTay Pet Supplies is considering discounting the price of all items by 10 percent. List the item ID, description, and discounted price for all items. Use DISCOUNTED_PRICE as the name for the computed column.
SELECT ITEM_ID, DESCRIPTION, PRICE * 0.9 AS DISCOUNTED_PRICE
FROM dbo.ITEM;
