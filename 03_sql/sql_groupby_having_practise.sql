DAY 7

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
tenure_months INT,
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
(4,'Virat Kohli','virat@gmail.com','Mumbai','2023-04-19'),
(5,'Sachin Tendulkar','sachin@gmail.com','Mumbai','2023-08-19'),
(6,'Rahul Dravid','rahul@gmail.com','Hyderabad','2023-09-13'),
(7,'Gautam Gambhir','gautam@gmail.com','Kochi','2023-10-04');

INSERT INTO loans VALUES
(101,1,36,500000,'Active','2023-02-01','2026-02-01'),
(102,2,24,300000,'Closed','2022-01-01','2024-01-01'),
(103,3,48,700000,'Active','2023-05-01','2027-05-01'),
(104,1,20,400000,'Active','2024-05-01','2026-01-01'),
(105,4,36,400000,'Active','2023-05-01','2026-05-01'),
(106,5,12,900000,'Closed','2023-09-18','2024-09-18'),
(107,6,48,800000,'Active','2024-03-04','2028-03-04'),
(108,7,21,300000,'Closed','2023-12-05','2025-10-02');

INSERT INTO payments VALUES
(1,101,'2023-03-10','2023-03-01',14000),
(2,101,'2023-04-10','2023-04-01',14000),
(3,102,'2022-01-25','2022-02-01',12500),
(4,101,'2023-05-10',NULL,14000),
(5,105,'2023-05-30','2023-06-01',11000),
(6,104,'2024-06-20','2024-06-10',16000),
(7,102,'2023-02-25','2024-04-12',16000),
(8,107,'2024-04-04','2024-04-04',13000),
(9,107,'2024-05-04','2024-05-03',13000)
;

SELECT * FROM customers;
SELECT * FROM loans;
SELECT * FROM payments;

-- 1.Customers with more than 1 loan
select customer_id, count(loan_id)
from loans
group by customer_id
having count(loan_id) >1;

-- 2.Loan status groups with high volume
select loan_status,count(loan_id) as count
from loans
group by loan_status
having count(loan_id)>2;

-- 3.High Value customers
select customer_id, sum(loan_amount) as total_loan
from loans
group by customer_id
having sum(loan_amount) > 300000;

-- 4.Tenure months

SELECT loan_start_date, loan_end_date,
TIMESTAMPDIFF (MONTH,loan_start_date,loan_end_date) as tenure
from loans;

-- 5.Average loans by tenure months
select tenure_months,avg(loan_amount) as avg_loan_amount
      from loans
	group by tenure_months 
    having avg(loan_amount) > 300000;

-- 6.NOn closed loan statuses where a large amount is still unpaind

select loan_status,sum(loan_amount) as total_loan_amount
from loans
where loan_status <> 'Closed'
group by loan_status
having sum(loan_amount) > 300000;
