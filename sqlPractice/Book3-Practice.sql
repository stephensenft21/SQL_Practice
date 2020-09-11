-- BOOK 3 chapter 1 PRACTICE -- Update Operations
-- This chapter covers writing UPDATE statements for modifying data.

-- The UPDATE statement is used to edit existing records in a table. First you will need to provide the table name, then use the SET clause to assign the values to the columns you wish to update.

-- You will likely need to add a WHERE clause to your statement to specify which records to update. If WHERE is not included then the UPDATE will apply to all records in the table.



-- Practice: Employees

-- PRACTICE QUESTION #1
-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location. 
-- She is currently at dealership 751. She would like to work at dealership 20. Update her record to reflect her transfer.

UPDATE public.dealershipemployees
SET dealership_id = 20
WHERE employee_id = 680 AND dealership_id = 751


-- PRACTICE QUESTION #2

-- Practice: Sales
-- A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express. Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.

UPDATE public.sales 
SET payment_method = LOWER('MasterCard')
WHERE customer_id = 13




-- BOOK 3 chapter 2 PRACTICE
-- Deleting Data
-- This chapter covers writing DELETE FROM statements and how they are affected by foreign key constraints.


-- Practice - Employees
-- A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer, 
-- last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '7628231837'.
        DELETE FROM sales
        WHERE invoice_number = '7628231837'
-- An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35. What problems might you run into when deleting? How would you recommend fixing it?
   
   UPDATE employees 
SET isACtive = false
WHERE employee_id = 35

SELECT *
FROM employees e
WHERE e.employee_id = 35

ALTER TABLE employees 
ADD COLUMN IF NOT EXISTS sACtive bool 
Default true

ALTER TABLE employees 
RENAME COLUMN sACtive TO isActive