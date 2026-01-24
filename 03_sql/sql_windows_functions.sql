USE loananalyticsdb;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE customers;
DROP TABLE loans;
DROP TABLE payments;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR (100),
email VARCHAR (100),
city VARCHAR(100),
created_date date
);


CREATE TABLE loans (
loan_id INT PRIMARY KEY,
customer_id INT,
loan_amount DECIMAL(10,2),
loan_status VARCHAR(20),
loan_start_date DATE,
loan_end_date DATE,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);



CREATE TABLE payments(
payment_id INT PRIMARY KEY,
loan_id INT,
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
(1,101,'2023-03-01',20000),
(2,101,'2023-04-01',20000),
(3,102,'2022-02-01',25000),
(4,101,'2024-06-01',25000),
(5,105,'2023-06-01',25000)
;

select * from customers;
select * from loans;
select * from payments;
...............................................................................
SELECT * 
FROM(
      SELECT
      loan_id,customer_id,loan_amount,loan_start_date,
      ROW_NUMBER () OVER (
      PARTITION BY customer_id
      ORDER BY loan_start_date DESC
      ) AS rn
      FROM loans
	)t
where rn=1;
      
-----------------------------------------------------------------------------------
SELECT customer_id,loan_amount,
RANK() OVER (ORDER BY loan_amount DESC)
from loans;
select * from loans;

---------------------------------------------------------------------------------
SELECT customer_id,sum(loan_amount) as total_amount
from loans
group by customer_id;
select * from loans;

select customer_id,loan_id,loan_amount,
sum(loan_amount) over (
partition by customer_id) as total_loan_per_customer
from loans;