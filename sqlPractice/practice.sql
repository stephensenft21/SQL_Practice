--  Write a query that returns the business name, city, state, and website for each dealership. 
-- Use an alias for the Dealerships table. 

-- Practice Question # 1
SELECT 
d.business_name, 
d.city, 
d.state, 
d.website 
from Dealerships d




--  Write a query that returns the first name, last name, and email address of every customer. Use an alias for the Customers table. 
-- Practice Question # 2

SELECT 
c.first_name, 
c.last_name, 
c.email 
from Customers c    



-- Using examples of the WHERE clause


-- #1 Customers who are from Texas:
SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	state = 'TX';


-- #2 Customers who are from Texas or Tennessee:
SELECT
	last_name, first_name, city, state
FROM
	customers
WHERE
	state = 'TX' OR state = 'TN';


--  #3 Customers who are from Texas, Tennessee or California:
SELECT
	last_name, first_name, city, state
FROM
	customers
WHERE
	state IN ('TX', 'TN', 'CA');


-- #4 Customers who are from states that start with the letter C:
SELECT
	last_name, first_name, city, state
FROM
	customers
WHERE
	state LIKE 'C%';


-- #5 Customers whose last name is greater than 5 characters and first name is less than or equal to 7 characters:
SELECT
	last_name, first_name
FROM
	customers
WHERE
	LENGTH(last_name) > 5 AND LENGTH(first_name) <= 7;


-- If you want to specify a range in the WHERE clause, use BETWEEN.

-- #6 Customers whose company name has between 10 and 20 characters (greater than or equal to 10 and less than or equal to 20):
SELECT
	last_name, first_name, company_name
FROM
	customers
WHERE
	LENGTH(company_name) BETWEEN 10 AND 20;

-- #7 Customers whose company name is null:
-- Because NULL is not equal to any value (even itself), this will not work.


-- !!WRONG SOLUTION!! --
SELECT
	last_name, first_name, company_name
FROM
	customers
WHERE
	company_name = NULL;


-- Instead, we do the following.

-- ***CORRECT SOLUTION*** --
SELECT
	last_name, first_name, company_name
FROM
	customers
WHERE
	company_name IS NULL;
-- ***CORRECT SOLUTION*** --




-- Practice: BOOK 2 CHAPTER 2 
    -- Carnival
-- #1 Get a list of sales records where the sale was a lease.
SELECT * , sales_type_id 
As "Lease" FROM sales 
WHERE sales_type_id  = 2

-- #2 Get a list of sales where the purchase date is within the last two years.

SELECT *, purchase_date AS "list of sales from the last two years" FROM sales
WHERE purchase_date  > '8-31-2018' 
ORDER BY purchase_date ASC

-- Get a list of sales where the deposit was above 5000 or the customer payed with American Express.

-- Get a list of employees whose first names start with "M" or ends with "E".
-- Get a list of employees whose phone numbers have the 600 area code.

