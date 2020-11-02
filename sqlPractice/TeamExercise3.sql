--Creating Carnival Reports


--GROUP PROJECT BOOK #3

-- QUESTION #1

/*Set up a trigger on the Sales table. When a new row is added, add a new record to the 
Accounts Receivable table with the deposit as credit_amount, 
the timestamp as date_received and the appropriate sale_id. */


CREATE OR replace FUNCTION new_accounts_receivable() 
RETURNS trigger 
LANGUAGE plpgsql 
AS $$

BEGIN
INSERT INTO accounts_receivable (
                credit_amount,
                debit_amount,
                date_received,
                sale_id
        )
VALUES (NEW.deposit, NULL, CURRENT_DATE, NEW.sale_id);
RETURN NULL;
END;
$$;
CREATE TRIGGER new_sale AFTER
INSERT ON sales
FOR EACH ROW EXECUTE PROCEDURE new_accounts_receivable();

/*Set up a trigger on the Sales table for when the sale_returned flag is updated. 
Add a new row to the Accounts Receivable table with the deposit as debit_amount, 
the timestamp as date_received, etc.*/

INSERT INTO sales ( sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method )
VALUES( 2,
        2,
        2,
        2,
        2,
        99999.11,
        9001,
        CURRENT_DATE,
        '09-29-2020',
        '1111021111',
        'jcb' )
select *
from sales
order by sale_id desc
select *
from accounts_receivable


/*
Create a stored procedure with a transaction to handle hiring a new employee. 
Add a new record for the employee in the Employees table and add a record to the 
Dealershipemployees table for the two dealerships the new employee will start at.
*/
CREATE OR replace FUNCTION check_account_update()
 RETURNS trigger 
 LANGUAGE plpgsql 
 AS $$ 
 BEGIN 
 
 IF NEW.returned = true THEN
INSERT INTO accounts_receivable (
                debit_amount,
                credit_amount,
                date_received,
                sale_id
        )
VALUES (NEW.deposit, 
NULL, 
CURRENT_DATE, 
NEW.sale_id);
RETURN NULL;
END IF;

END;
$$

--TRIGGER FOR CHECK_ACCOUNT_UPDATE
CREATE TRIGGER vehicle_returned AFTER
UPDATE ON sales
FOR EACH ROW EXECUTE PROCEDURE check_account_update();


-- select *
-- from sales
-- order by vehicle_id asc 

CALL returning_sold_vehicle(9);


-- select *

CREATE OR REPLACE PROCEDURE hire_employee( IN first_name varchar, 
                                            last_name varchar, 
                                            email_address varchar, 
                                            phone varchar, 
                                            employee_type_id int, 
                                            is_active boolean, 
                                            dealership_one int, 
                                            dealership_two int ) 
                                            LANGUAGE plpgsql 
                                            AS $$
DECLARE NewEmployeeId integer;
BEGIN
INSERT INTO employees(
                first_name,
                last_name,
                email_address,
                phone,
                employee_type_id,
                is_active
        )
VALUES (
                first_name,
                last_name,
                email_address,
                phone,
                employee_type_id,
                is_active
        )
RETURNING employee_id INTO NewEmployeeId;
COMMIT;

INSERT INTO dealershipemployees(employee_id, dealership_id)
VALUES(NewEmployeeId, dealership_one);

COMMIT;

INSERT INTO dealershipemployees(employee_id, dealership_id)
VALUES(NewEmployeeId, dealership_two);

END;
$$;

CALL hire_employee( 'Thomas', 'Dude', 'thomas@gmail.com', '604-976-5243', 6, true, 901, 3)

select *
from employees
order by employee_id desc
select *
from dealershipemployees
where employee_id = 1011