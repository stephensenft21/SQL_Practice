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
	c.last_name,
	c.first_name,
	c.city,
	c.state
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
As "Lease"
FROM sales
WHERE sales_type_id  = 2

-- #2 Get a list of sales where the purchase date is within the last two years.

SELECT *, purchase_date AS "list of sales from the last two years"
FROM sales
WHERE purchase_date  > '8-31-2018'
ORDER BY purchase_date ASC

-- #3 Get a list of sales where the deposit was above 5000 or the customer payed with American Express.
SELECT *
FROM Sales
WHERE deposit > 5000
	or payment_method 
LIKE '%American Express%'
ORDER BY deposit ASC;

-- #4 Get a list of employees whose first names start with "M" or ends with "E".
SELECT first_name
FROM Employees
Where first_name LIKE 'M%' OR first_name LIKE '%e'

-- #5 Get a list of employees whose phone numbers have the 600 area code.
SELECT phone
FROM employees
Where phone LIKE '600%'

-- Practice: BOOK 2 CHAPTER 3 
-- Carnival


-- 1# Get a list of the sales that was made for each sales type.
SELECT s.*, st.name
FROM SALES s
	INNER JOIN salestypes st
	ON st.sales_type_id = s.sales_type_id

-- 2# Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, first name and last name of the employee who made the sale and the name, city and state of the dealership.

SELECT
	v.vin,
	c.first_name as customer_first_name,
	c.last_name as customer_last_name,
	e.first_name,
	e.last_name,
	d.business_name,
	d.city,
	d.state
FROM sales s
	JOIN vehicles v ON s.vehicle_id = v.vehicle_id
	JOIN customers c ON s.customer_id = c.customer_id
	JOIN employees e ON s.employee_id = e.employee_id
	JOIN dealerships d ON s.dealership_id = d.dealership_id;

-- 3# Get a list of all the dealerships and the employees, if any, working at each one.
SELECT d.business_name,
	CONCAT(e.first_name, ' ', e.last_name) 
as employee_name
FROM dealerships d
	LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
	LEFT JOIN employees e ON e.employee_id = de.employee_id;
-- 4# Get a list of vehicles with the names of the body type, make, model and color.
SELECT v.vin, bt.name, ma.name, mo.name 
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id






