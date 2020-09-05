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




-- Practice: Sales Type by Dealership
-- 1# Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT
d.business_name, 
st.name, Count(s.sale_id) AS number_of_sales
FROM dealerships d 
JOIN sales s ON s.dealership_id = d.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
-- WHERE st.sales_type_id = 2
GROUP BY d.dealership_id, st.sales_type_id
ORDER BY d.dealership_id

-- Practice: Leased Types
-- 2# Produce a report that determines the most popular vehicle model that is leased.

SELECT mo.name, COUNT(s.sale_id) AS lease_count
FROM sales s
JOIN salestypes st ON st.sales_type_id = s.sales_type_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
WHERE s.sales_type_id = 2 
GROUP BY mo.vehicle_model_id
ORDER BY COUNT(s.sale_id) DESC;

--  Who Sold What

-- 3# What is the most popular vehicle make in terms of number of sales?
SELECT ma.name AS make_name, COUNT(s.sale_id) AS number_of_sales
FROM sales s
JOIN salestypes st ON st.sales_type_id = s.sales_type_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id
ORDER BY COUNT(s.sale_id) DESC;




-- 4# Which employee type sold the most of that make?
SELECT et.name, COUNT(s.employee_id)
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN employees e ON s.employee_id = e.employee_id
JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
WHERE ma.vehicle_make_id = 
(
    SELECT ma.vehicle_make_id 
	FROM sales s
	JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
    GROUP BY ma.vehicle_make_id
	ORDER BY COUNT(s.sale_id) DESC
	LIMIT 1
)
GROUP BY et.employee_type_id
ORDER BY COUNT(s.employee_id) DESC





-- Practice: BOOK 2 CHAPTER 8
-- Carnival
-- In this chapter, you are going to practice using filters and joins to produce different sales reports for the Carnival platform.

-- You will be using the following SQL keywords/functions.

-- SELECT
-- FROM
-- JOIN
-- GROUP BY
-- ORDER BY
-- WHERE
-- AND
-- SUM()
-- MAX()
-----------------------------------------------------------------------------------------------------------------------------------

-- Purchase Income by Dealership


-- 1# Write a query that shows the total purchase sales income per dealership.




-- 2# Write a query that shows the purchase sales income per dealership for the current month.
-- 3# Write a query that shows the purchase sales income per dealership for the current year.

--  Lease Income by Dealership
-- 4# Write a query that shows the total lease income per dealership.
-- 5# Write a query that shows the lease income per dealership for the current month.
-- 6# Write a query that shows the lease income per dealership for the current year.

--  Total Income by Employee
-- 7# Write a query that shows the total income (purchase and lease) per employee.



-- Practice: BOOK 2 CHAPTER 9

-- Carnival Inventory

-- In this chapter, you will be writing queries to produce reports about the inventory of vehicles at dealerships on the Carnival platform.
-------------------------------------------------------------------------------------------------------------------------------------------

-- Available Models
-- 1# Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.
-- 2# Which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.
-- Diverse Dealerships
-- 3# Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.
-- 4# Which dealerships are currently selling the highest number of vehicle models? This will let dealerships know which regions have either a high population, or less brand loyalty.





-- Practice: BOOK 2 CHAPTER 9
