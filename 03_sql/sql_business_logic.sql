USE loananalyticsdb;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE customers;
DROP TABLE loans;
DROP TABLE payments;
SET FOREIGN_KEY_CHECKS=1;

-- created customers_table
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR (100),
email VARCHAR (100),
city VARCHAR(100),
created_date date
);

-- created loans_table
CREATE TABLE loans (
loan_id INT PRIMARY KEY,
customer_id INT,
loan_amount DECIMAL(10,2),
loan_status VARCHAR(20),
loan_start_date DATE,
loan_end_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- created payments table

CREATE TABLE payments(
payment_id INT PRIMARY KEY,
loan_id INT,
due_date DATE,
payment_date DATE,
amount_paid DECIMAL(10,2),
FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

INSERT INTO customers VALUES
(1,'Ravi Kumar','ravi@gmail.com','Bangalore','2023-01-10'),
(2,'Anita Sharma','anita@gmail.com','Chennai','2023-02-12'),
(3,'Suresh Rao','suresh@gmail.com','Hyderabad','2023-03-15'),
(4,'Virat Kohli','virat@gmail.com','Mumbai','2023-04-19');

INSERT INTO loans VALUES
(101,1,500000,'Active','2023-02-01','2026-02-01'),
(102,2,300000,'Closed','2022-01-01','2024-01-01'),
(103,3,700000,'Active','2023-05-01','2027-05-01'),
(104,1,400000,'Active','2024-05-01','2026-01-01'),
(105,4,400000,'Active','2023-05-01','2026-07-01');

INSERT INTO payments VALUES
(1,101,'2023-03-10','2023-03-01',14000),
(2,101,'2023-04-10','2023-04-01',14000),
(3,102,'2022-01-25','2022-02-01',12500),
(4,101,'2023-05-10',NULL,14000),
(5,105,'2023-05-30','2023-06-01',11000),
(6,104,'2024-06-20','2024-06-10',16000),
(7,102,'2023-02-25','2024-04-12',16000)
;

select * from customers;
select * from loans;
select * from payments;

--- EMI status logic

select payment_id,loan_id,due_date,payment_date,
       CASE 
       WHEN payment_date IS NULL THEN 'Not Paid'
       WHEN payment_date <= due_date THEN 'On-Time'
       ELSE 'Delayed'
       END as EMI_status
from payments;

----DELAY Flag(YES/NO)
 Select payment_id,loan_id,due_date,payment_date,
       CASE
       WHEN payment_date IS NULL THEN 1
       WHEN payment_date >= due_date THEN 1
       ELSE 0
       END as Delay_flag
from payments;


---------------------------------------------------------------------

--- DEFAULT logic: payments delayed beyond 30 days. 
--- For unpaid records, we compare the due date with the current date to determine if the loan has crossed the default threshold

-- METHOD 1
select payment_id,loan_id,due_date,payment_date,
     CASE
     WHEN payment_date IS NULL 
           AND CURDATE() > DATE_ADD(due_date, INTERVAL 30 DAY) THEN 1
	 WHEN payment_date > due_date 
           AND DATEDIFF(payment_date,due_date) >30 THEN 1
	ELSE 0
    END AS Default_flag
from payments;
           
-- METHOD 2
       select payment_id,loan_id,due_date,payment_date,
     CASE
        WHEN DATEDIFF(
                        IFNULL(payment_date,CURDATE()),
                        due_date
					) >30 THEN 1
		ELSE 0
	END AS default_flag_2
from payments;

------------------------------------------------------------------

-- OUTSTANDING AMOUNTS
select * from customers;
select * from loans;
select * from payments;

SELECT l.loan_id, l.loan_amount,
        ifnull(sum(amount_paid),0) as total_paid,
		l.loan_amount-ifnull(sum(p.amount_paid),0) as outstanding_amount
from loans l
 left join
 payments p on l.loan_id=p.loan_id
 group by  l.loan_id, l.loan_amount;
 
 
 ------------------------
 -- PROFIT = Total emi paid-principal

SELECT 
    p.loan_id,
    SUM(p.amount_paid) - l.loan_amount AS profit
FROM payments p
JOIN loans l 
    ON p.loan_id = l.loan_id
GROUP BY p.loan_id, l.loan_amount;


  



