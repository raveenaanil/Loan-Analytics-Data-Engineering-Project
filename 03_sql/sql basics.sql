USE LoanAnalyticsDB;

CREATE TABLE customers(
   customer_id INT PRIMARY KEY,
   customer_name VARCHAR(100),
   city VARCHAR(50),
   income DECIMAL(10,2),
   credit_score INT
   
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL (12,2),
    interest_rate DECIMAL (5,2),
    loan_start_date DATE,
    loan_end_date DATE,
    loan_status VARCHAR(20),
    FOREIGN KEY (customer_id ) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1,'Ravi Kumar','Bangalore',60000,750),
(2,'Anita Sharma','Chennai',50000,720),
(3,'Suresh Iyer','Mumbai',80000,780),
(4,'Meena Nair','Kochi',45000,690);

INSERT INTO loans VALUES
(101,1,500000,10.5,'2023-01-01','2026-01-01','Active'),
(102,2,300000,11.0,'2022-06-01','2025-06-01','Active'),
(103,3,700000,9.5,'2021-03-01','2024-03-01','Active'),
(104,4,200000,12.0,'2023-07-01','2026-07-01','Active');

select * from customers;

select customer_name,income
from customers
where income>50000;

select sum(loan_amount) as total_loan_amount
from loans;


select avg(loan_amount) as avg_loan_amount
from loans;

select count(*) as active_loans
from loans
where loan_status="Active";


select loan_status, count(*) AS loan_count
from loans
group by loan_status;

select max(loan_amount) as max_loan
from loans;

select min(loan_amount) as min_loan
from loans;

select loan_id,loan_start_date
from loans
where loan_start_date > '2022-01-01';

select avg(interest_rate) as avg_interest
from loans;
