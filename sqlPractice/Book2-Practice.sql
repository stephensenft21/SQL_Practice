-- Practice: BOOK 2 CHAPTER 2
-- Carnival
-- #1 Get a list of sales records where the sale was a lease.
SELECT *,
	sales_type_id As "Lease"
FROM sales
WHERE sales_type_id = 2 -- #2 Get a list of sales where the purchase date is within the last two years.
SELECT *,
	purchase_date AS "list of sales from the last two years"
FROM sales
WHERE purchase_date > '8-31-2018'
ORDER BY purchase_date ASC -- #3 Get a list of sales where the deposit was above 5000 or the customer payed with American Express.
SELECT *
FROM Sales
WHERE deposit > 5000
	or payment_method LIKE '%American Express%'
ORDER BY deposit ASC;
-- #4 Get a list of employees whose first names start with "M" or ends with "E".
SELECT first_name
FROM Employees
Where first_name LIKE 'M%'
	OR first_name LIKE '%e' -- #5 Get a list of employees whose phone numbers have the 600 area code.
SELECT phone
FROM employees
Where phone LIKE '600%' -- Practice: BOOK 2 CHAPTER 3
	-- Carnival
	-- 1# Get a list of the sales that was made for each sales type.
SELECT s.*,
	st.name
FROM SALES s
	INNER JOIN salestypes st ON st.sales_type_id = s.sales_type_id -- 2# Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, first name and last name of the employee who made the sale and the name, city and state of the dealership.
SELECT v.vin,
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
	CONCAT(e.first_name, ' ', e.last_name) as employee_name
FROM dealerships d
	LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
	LEFT JOIN employees e ON e.employee_id = de.employee_id;
-- 4# Get a list of vehicles with the names of the body type, make, model and color.
SELECT v.vin,
	bt.name,
	ma.name,
	mo.name
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
	JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id -- Practice: Sales Type by Dealership
	-- 1# Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT d.business_name,
	st.name,
	Count(s.sale_id) AS number_of_sales
FROM dealerships d
	JOIN sales s ON s.dealership_id = d.dealership_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id -- WHERE st.sales_type_id = 2
GROUP BY d.dealership_id,
	st.sales_type_id
ORDER BY d.dealership_id -- Practice: Leased Types
	-- 2# Produce a report that determines the most popular vehicle model that is leased.
SELECT mo.name,
	COUNT(s.sale_id) AS lease_count
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
SELECT ma.name AS make_name,
	COUNT(s.sale_id) AS number_of_sales
FROM sales s
	JOIN salestypes st ON st.sales_type_id = s.sales_type_id
	JOIN vehicles v ON s.vehicle_id = v.vehicle_id
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id
ORDER BY COUNT(s.sale_id) DESC;
-- 4# Which employee type sold the most of that make?
SELECT et.name,
	COUNT(s.employee_id)
FROM sales s
	JOIN vehicles v ON s.vehicle_id = v.vehicle_id
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
	JOIN employees e ON s.employee_id = e.employee_id
	JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
WHERE ma.vehicle_make_id = (
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
ORDER BY COUNT(s.employee_id) DESC -- Practice: BOOK 2 CHAPTER 8
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
SELECT d.business_name,
	SUM(s.price) AS total_purchase_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY SUM(s.price) DESC -- 2# Write a query that shows the purchase sales income per dealership for the current month.
SELECT d.business_name,
	SUM(s.price) AS total_purchase_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.purchase_date >= '2020-04-01'
	AND s.purchase_date <= '2020-04-30'
GROUP BY d.dealership_id,
	s.purchase_date;
-- 3# Write a query that shows the purchase sales income per dealership for the current year.
SELECT d.business_name,
	s.purchase_date,
	SUM(s.price) AS total_purchase_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE s.purchase_date >= '2020-01-01'
	AND s.purchase_date <= '2020-12-31'
GROUP BY d.dealership_id,
	s.purchase_date
ORDER BY s.purchase_date ASC;
--  Lease Income by Dealership
-- 4# Write a query that shows the lease income per dealership for the current month.
SELECT d.business_name,
	st.sales_type_id,
	SUM(s.price) AS total_lease_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE)
GROUP BY d.dealership_id,
	st.sales_type_id
ORDER BY SUM(s.price) DESC -- 5# Write a query that shows the total lease income per dealership.
SELECT d.business_name,
	st.sales_type_id,
	SUM(s.price) AS total_lease_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE LOWER(st.name) LIKE '%lease%'
GROUP BY d.dealership_id,
	st.sales_type_id
ORDER BY SUM(s.price) DESC -- 6# Write a query that shows the lease income per dealership for the current year.
SELECT d.business_name,
	st.sales_type_id,
	SUM(s.price) AS total_lease_income,
	Count(s.sale_id)
FROM sales s
	JOIN dealerships d ON s.dealership_id = d.dealership_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE LOWER(st.name) LIKE '%lease%'
	AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY d.dealership_id,
	st.sales_type_id
ORDER BY SUM(s.price) DESC --  Total Income by Employee
	-- 7# Write a query that shows the total income (purchase and lease) per employee.
SELECT CONCAT(e.first_name, '', e.last_name) AS employee,
	SUM(s.price)
FROM SALES s
	JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_id -- Practice: BOOK 2 CHAPTER 9
	-- Carnival Inventory
	-- In this chapter, you will be writing queries to produce reports about the inventory of vehicles at dealerships on the Carnival platform.
	-------------------------------------------------------------------------------------------------------------------------------------------
	-- Available Models
	-- 1# Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.
SELECT COUNT(v.vehicle_type_id) AS current_inventory,
	vm.name,
	vm.vehicle_model_id
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
GROUP BY vm.vehicle_model_id
ORDER BY COUNT(v.vehicle_type_id) -- ANSWER: ATLAS
	-- 2# Which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.
SELECT COUNT(v.vehicle_type_id) AS current_inventory,
	vm.name,
	ma.name
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY vm.vehicle_model_id,
	ma.name
ORDER BY COUNT(v.vehicle_type_id) DESC -- Diverse Dealerships
	-- 3# Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.
	-- 4# Which dealerships are currently selling the highest number of vehicle models? This will let dealerships know which regions have either a high population, or less brand loyalty.
	-- Practice: BOOK 2 CHAPTER 10
	-- Employee Reports
	-- 1# How many emloyees are there for each role?
SELECT COUNT(CONCAT(e.first_name, '', e.last_name)) AS "Employee",
	et.name AS "Employee Type"
FROM employees e
	LEFT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
GROUP BY et.employee_type_id
ORDER BY COUNT(et.employee_type_id) DESC -- 2# How many finance managers work at each dealership?
SELECT d.business_name,
	COUNT(CONCAT(e.employee_id)) AS num_of_managers
FROM employeetypes et
	JOIN employees e ON et.employee_type_id = e.employee_type_id
	JOIN dealershipemployees de ON de.employee_id = e.employee_id
	JOIN dealerships d ON de.dealership_id = d.dealership_id
WHERE LOWER(et.name) LIKE '%finance%'
GROUP BY d.dealership_id,
	et.name
ORDER BY COUNT(d.dealership_id) DESC;
-- 3# Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT e.first_name,
	e.last_name,
	COUNT(d.dealership_id)
FROM employees e
	JOIN dealershipemployees de ON de.employee_id = e.employee_id
	JOIN dealerships d ON de.dealership_id = d.dealership_id
GROUP BY e.employee_id
ORDER BY COUNT(d.dealership_id) DESC
LIMIT 3;
-- 4# Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT e.first_name,
	e.last_name,
	COUNT(s.sale_id)
FROM employees e
	JOIN sales s ON s.employee_id = e.employee_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE LOWER(st.name) LIKE '%lease%'
GROUP BY e.employee_id
ORDER BY COUNT(s.sale_id) DESC
LIMIT 2;
-- 5# Get a report on the the two employees who has made the least number of non-lease sales.
SELECT e.first_name,
	e.last_name,
	COUNT(s.sale_id)
FROM employees e
	JOIN sales s ON s.employee_id = e.employee_id
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE LOWER(st.name) NOT LIKE '%lease%'
GROUP BY e.employee_id
ORDER BY COUNT(s.sale_id) ASC
LIMIT 2;
-- Practice: BOOK 2 CHAPTER 11
-- Carnival Customers
-- In these exercises, you will be using data from the Customers table. You will need to use the following concepts.
-- Sub-queries or CTE
-- AVG() function
-- COUNT() function
-- JOIN
-- GROUP BY
-- ORDER BY
-- LIMIT
--------------------------------------------------------------------------------------------------------------------
-- 1# States With Most Customers
-- 2# What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT c.state,
	COUNT(s.sale_id)
FROM customers c
	JOIN sales s ON s.customer_id = c.customer_id
	JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY c.state
ORDER BY COUNT(s.sale_id) DESC
LIMIT 5 -- 3# What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT c.zipcode,
	COUNT(s.sale_id)
FROM customers c
	JOIN sales s ON s.customer_id = c.customer_id
	JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY c.zipcode
ORDER BY COUNT(s.sale_id) DESC
LIMIT 5 -- 4# What are the top 5 dealerships with the most customers?
SELECT d.business_name,
	COUNT(c.customer_id)
FROM customers c
	JOIN sales s ON s.customer_id = c.customer_id
	JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.dealership_id
ORDER BY COUNT(c.customer_id) DESC
LIMIT 5 -- Practice: BOOK 2 CHAPTER 12
	-- Views
	-- Advantages of Using Views
	-- Views can simplify complex queries that contain data from multiple tables and/or do aggregate functions.
	-- A view can limit the degree of exposure of the underlying tables to the outer world. If you have a table with sensitive information. You can create a view that limits the data shown from the table and give users only the view.
	-- Views can simplify the presented data. You could have a different view for smaller, filtered subsets of data from a larger table.
	-- Because only the query is stored and not the result set, they take up very little storage space.
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Practice: Carnival Views
	-- 1# Create a view that lists all vehicle body types, makes and models.
	CREATE VIEW vehicle_make_model_body_type AS (
		SELECT v.vin,
			ma.name AS make,
			mo.name AS model,
			bt.name AS body_type
		FROM vehicles v
			JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
			JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
			JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
			JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
	)
SELECT vin,
	make,
	model,
	body_type
FROM vehicle_make_model_body_type 

-- 2# Create a view that shows the total number of employees for each employee type.
	CREATE VIEW total_employee_by_type AS (
		SELECT COUNT(e.employee_id),
			et.name
		FROM employees e
			JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
		GROUP BY et.name
		ORDER BY COUNT(et.name)
	) 
	
	-- 3# Create a view that lists all customers without exposing their emails, phone numbers and street address.
	CREATE VIEW limited_customer_info_view AS (
		SELECT c.first_name AS first_name,
			c.last_name AS last_name,
			c.city AS city,
			c.state AS state,
			c.zipcode AS zipcode,
			c.company_name AS company_name
		FROM customers c
	) 
	-- 4# Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.
	CREATE VIEW sales_2018_view AS
SELECT SUM(ROUND(s.price, 2)) AS total_sales,
	st.name AS sales_type
FROM sales s
	JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE s.purchase_date >= '2018-01-01'
	AND s.purchase_date < '2018-12-31'
GROUP BY st.sales_type_id
SELECT *
FROM sales_2018_view 

-- 5# Create a view that shows the employee at each dealership with the most number of sales.
	-- Practice: BOOK 2 CHAPTER 13
	-- Converting Your Practice Queries into Views
	-- It's time to convert some of your report queries into views so that other database developers, and application developers can quickly gain access to useful reports without having to write their own SQL.
	-- Review all of the queries that you wrote for chapters 8, 9, 10, and 11.
	-- Determine which of those views you feel would be most useful over time. Consider the view itself, or how it could be integrated into another query and/or view.
	-- If there were several software applications written that access this database (e.g. HR applications, sales/tax applications, online purchasing applications, etc.), which, if any of your queries should be converted into views that multiple applications would like use?
	-- Be prepared to discuss, and defend your choices in the next class.
	-- Creating Carnival Reports
	-- Carnival would like to harness the full power of reporting. Let's begin to look further at querying the data in our tables. Carnival would like to understand more about thier business and needs you to help them build some reports.
	-- Goal
	-- Below are some desired reports that Carnival would like to see. Use your query knowledge to find the following metrics.
	-- Employee Reports
	-- Best 
	
	
	-- Who are the top 5 employees for generating sales income?
Select sum(s.price) as total_sales_income,
	e.first_name,
	e.last_name
FROM Sales s
	Join Employees e ON s.employee_id = e.employee_id
Group By e.first_name,
	e.last_name
Order BY sum(s.price) DESC
LIMIT 5;
-- Who are the top 5 dealership for generating sales income?
Select sum(s.price),
	d.business_name
FROM Sales s
	Join Dealerships d ON s.dealership_id = d.dealership_id
Group By d.business_name
Order BY sum(s.price) DESC
LIMIT 5;
-- Which vehicle model generated the most sales income?
SELECT sum(s.price),
	vm.name
FROM Sales s
	JOIN Vehicles v ON s.vehicle_id = v.vehicle_id
	JOIN Vehicletypes vt on v.vehicle_type_id = vt.vehicle_type_id
	JOIN Vehiclemodels vm on vt.model_id = vm.vehicle_model_id
Group By vm.name
Order By sum(s.price) DESC
LIMIT 1;
-- Top Performance
-- Which employees generate the most income per dealership?
Select sum(s.price) as total_sales_income,
	d.business_name,
	e.first_name,
	e.last_name
FROM Dealerships d
	JOIN Sales s ON s.dealership_id = d.dealership_id
	JOIN Employees e ON e.employee_id = s.employee_id
GROUP BY d.business_name,
	e.first_name,
	e.last_name
ORDER BY sum(s.price) DESC -- Vehicle Reports
	-- Inventory
	-- In our Vehicle inventory, show the count of each Model that is in stock.
SELECT COUNT(v.vehicle_type_id) AS current_inventory,
	vm.name,
	ma.name
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemodels vm ON vt.model_id = vm.vehicle_model_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY vm.vehicle_model_id,
	ma.name
ORDER BY COUNT(v.vehicle_type_id) DESC;
-- In our Vehicle inventory, show the count of each Make that is in stock.
SELECT COUNT(ma.vehicle_make_id) AS current_inventory,
	ma.name
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id,
	ma.name
ORDER BY COUNT(ma.vehicle_make_id) DESC -- In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT COUNT(bt.vehicle_body_type_id) AS current_inventory,
	bt.name
FROM vehicles v
	JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
GROUP BY bt.vehicle_body_type_id,
	bt.name
ORDER BY COUNT(bt.vehicle_body_type_id) DESC;
-- Purchasing Power
-- Which US state's customers have the highest average purchase price for a vehicle?
SELECT ROUND(avg(s.price), 2) as average_purchase_price,
	c.state
FROM Sales s
	JOIN Customers c ON c.customer_id = s.customer_id
GROUP BY c.state
ORDER BY avg(s.price) DESC
LIMIT 1;
-- Of the 5 US states with the most customers that you determined above, which of those have the customers with the highest average purchase price for a vehicle?
SELECT ROUND(avg(s.price), 2) as average_purchase_price,
	c.state
FROM Sales s
	JOIN Customers c ON c.customer_id = s.customer_id
GROUP BY c.state
ORDER BY avg(s.price) DESC
LIMIT 5;