-- BOOK 3 chapter 1 PRACTICE -- Update Operations
-- This chapter covers writing UPDATE statements for modifying data.
-- The UPDATE statement is used to edit existing records in a table. First you will need to provide the table name, then use the SET clause to assign the values to the columns you wish to update.
-- You will likely need to add a WHERE clause to your statement to specify which records to update. If WHERE is not included then the UPDATE will apply to all records in the table.
-- Practice: Employees
-- PRACTICE QUESTION #1
-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location.
-- She is currently at dealership 751. She would like to work at dealership 20. Update her record to reflect her transfer.
-----------------------------------------------

UPDATE dealershipemployees
SET dealership_id = 20
WHERE employee_id = 680
        AND dealership_id = 751 -----------------------------------------------
 -- PRACTICE QUESTION #2
 -- Practice: Sales
 -- A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express. Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.
 ----------------------------------------

        UPDATE sales
        SET payment_method = LOWER('MasterCard') WHERE customer_id = 13 ----------------------------------------
 -- BOOK 3 chapter 2 PRACTICE
 -- Deleting Data
 -- This chapter covers writing DELETE FROM statements and how they are affected by foreign key constraints.
 -- Practice - Employees
 -- A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer,
 -- last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '7628231837'.

        DELETE
        FROM sales WHERE invoice_number = '7628231837' -- An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35. What problems might you run into when deleting? How would you recommend fixing it?
 ---------------------------------

        UPDATE employees
        SET isACtive = false WHERE employee_id = 35
        SELECT *
        FROM employees e WHERE e.employee_id = 35
        ALTER TABLE employees ADD COLUMN IF NOT EXISTS sACtive bool Default true
        ALTER TABLE employees RENAME COLUMN sACtive TO isActive -----------------------------------
 -- Selling a Vehicle
 -- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. They plan to do this by flagging the vehicle as is_sold
 --  which is a field on the Vehicles table. When set to True this flag will indicate that the vehicle is no longer available in the inventory.
 --  Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

        SELECT *
        FROM vehicles WHERE vehicle_id = 2 --Creating a stored procedure to remove a vehicle from inventory whenever a vehicle is sold
 -------------------------------------------------------------

        CREATE PROCEDURE remove_vehicle_from_inventory(vehicleId int) 
        LANGUAGE plpgsql 
         $$
          BEGIN
UPDATE vehicles v
SET is_sold = true
WHERE v.vehicle_id = vehicleId;
END $$;

CALL remove_vehicle_from_inventory(5) ------------------------------------------------------------
--Creating a stored procedure to return a sold vehicle
------------------------------------------------------------

CREATE PROCEDURE returning_sold_vehicle(in vehicleId int) LANGUAGE plpgsql AS $$ BEGIN
UPDATE sales
SET returned = true
WHERE vehicle_id = vehicleId;
UPDATE vehicles
SET is_sold = false
WHERE vehicle_id = vehicleId;
END $$;

CALL returning_sold_vehicle(1);

-------------------------------------------------------------
--Creating a stored procedure to return a vehicle to to inventory and change the vehicles oil
---------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE return_sold_vehicle_with_oil_change(in vehicleId int) LANGUAGE plpgsql AS $$ BEGIN
UPDATE sales
SET returned = true
WHERE vehicle_id = vehicleId;
UPDATE vehicles
SET is_sold = false
WHERE vehicle_id = vehicleId;
INSERT INTO oilchangelogs(date_occured, vehicle_id)
VALUES (CURRENT_DATE, vehicleId);
END $$;

CALL return_sold_vehicle_with_oil_change(2);

--------------------------------------------------------------------------------
-- SELECT v.vehicle_id, v.vin, s.returned, v.is_sold, o.date_occured FROM vehicles v
-- LEFT JOIN sales s ON v.vehicle_id = s.vehicle_id
-- LEFT JOIN oilchangelogs o ON v.vehicle_id = o.vehicle_id
-- WHERE v.vehicle_id = 2;
-- CHAPTER 5
-- Triggers Introduction
-- QUESTION #1
-- Create a trigger for when a new Sales record is added,
--set the purchase date to 3 days from the current date.
-----------------------------------

CREATE FUNCTION set_purchase_date() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$ BEGIN
UPDATE sales s
SET s.purchase_date = current_date + 3
WHERE s.sale_id = NEW.sale_id;
RETURN NULL;
END;
$$
CREATE TRIGGER new_sale_added AFTER
INSERT ON sales
FOR EACH ROW EXECUTE PROCEDURE set_purchase_date();

--------------------------------------
-- QUESTION #2
---------------------------------------------------------

CREATE FUNCTION set_pickup_date() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$ BEGIN
UPDATE sales s
SET s.pickup_date = NEW.purcahse_date + interval '7 days'
WHERE s.sale_id = NEW.sale_id;
RETURN NULL;
END;
$$
CREATE TRIGGER new_sale_made AFTER
INSERT ON sales
FOR EACH ROW EXECUTE PROCEDURE set_pickup_date();

--------------------------------------------------------
-- QUESTION #3
-- Create a trigger for updates to the Sales table.If the pickup date is on or before the purchase date, set the pickup date
-- to 7 days after the purchase date. If the pickup date is after the purchase date but less than 7 days out from the purchase date,
-- add 4 additional days to the pickup date.
--':=' is for assignment.
-- '=' is for comparison.
----------------------------------------------------------

CREATE OR REPLACE FUNCTION conditionally_set_pickup_date() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$ BEGIN IF NEW.pickup_date > NEW.purchase_date
        AND NEW.pickup_date <= NEW.purchase_date + integer '7' THEN NEW.pickup_date := NEW.pickup_date + integer '4';
ELSEIF NEW.pickup_date <= NEW.purchase_date THEN NEW.pickup_date := NEW.purchase_date + '7';
END IF;
RETURN NEW;
END;
$$
CREATE TRIGGER update_sale_made_pickup_date
BEFORE
UPDATE ON sales
FOR EACH ROW EXECUTE PROCEDURE conditionally_set_pickup_date();

--------------------------------------------------
--CHECK TO SEE IF TRIGGER FUNCTION WORKS!!
----------------------------------------------------

UPDATE sales
SET pickup_date = purchase_date +
WHERE sale_id > 999;


SELECT *
FROM sales
ORDER BY sale_id DESC;

----------------------------------------------------
--CHAPTER 6
-- Carnival Dealerships
-- TRIGGER PRACTICE QUESTIONS
-- QUESTION #1
-- Because Carnival is a single company, we want to ensure that there is consistency in the data provided to the user.
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
-- Therefore, any time a new dealership is added or an existing dealership is updated, we want to ensure that the website URL has the following format: 
-- http://www.carnivalcars.com/{name of the dealership with underscores separating words}.
------------------------------------------------------------------------------------------

CREATE FUNCTION format_dealership_website()
 RETURNS TRIGGER 
 LANGUAGE PlPGSQL 
 AS $$ BEGIN 
 
 -- trigger function logic
NEW.website := CONCAT(
        'http://www.carnivalcars.com/',
        REPLACE(LOWER(NEW.business_name), ' ', '_')
);
RETURN NEW;
END;
$$
CREATE TRIGGER dealership_website
BEFORE
INSERT
OR
UPDATE ON dealerships
FOR EACH ROW EXECUTE PROCEDURE format_dealership_webiste();

------------------------------------------------------------------------------------------
-- QUESTION #2
-- If a phone number is not provided for a new dealership, set the phone number to the default customer care number 777-111-0305.
------------------------------------------------------------------------------------------

CREATE FUNCTION default_phone_number() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$ BEGIN
UPDATE dealerships d
SET d.phone = '777-111-0305'
WHERE d.phone IS NULL
        AND d.dealership_id = NEW.dealership_id;
RETURN NULL;
END;
$$
CREATE trigger add_default_phone_number AFTER
INSERT ON dealerships
for each row EXECUTE PROCEDURE default_phone_number();

------------------------------------------------------------------------------------------
-- QUESTION #3
-- For accounting purposes, the name of the state needs to be part of the dealership's tax id. 
-- For example, if the tax id provided is bv-832-2h-se8w for a dealership in Virginia, then it needs to be put into the database as bv-832-2h-se8w--virginia.
------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION set_state_in_tax_id() RETURNS TRIGGER LANGUAGE PlPGSQL AS $$ BEGIN IF OLD.tax_id NOT LIKE '%-%-%-%--%'
        AND NEW.tax_id NOT LIKE '%-%-%-%--%' THEN NEW.tax_id := CONCAT(NEW.tax_id, '--', LOWER(NEW.state));
END IF;
RETURN NEW;
END;
$$
CREATE TRIGGER dealership_tax_id
BEFORE
INSERT
OR
UPDATE ON dealerships
FOR EACH ROW EXECUTE PROCEDURE set_state_in_tax_id();

------------------------------------------------------------------------------------------


