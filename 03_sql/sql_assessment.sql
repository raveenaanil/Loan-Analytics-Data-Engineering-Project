-- Loan Analytics Mini SQL Assessment
-- Covers joins, aggregations,window functions and business logic

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

-- 1.Total number of active loans
select * from loans;
select count(*) AS total_active_loans
from loans
where loan_status='Active';

-- 2.Total approved loan amount
select sum(loan_amount) as total_approved_amount
from loans;

-- 3.Total Outstanding amount per loan
select * from loans;
select * from customers;
select * from payments;

select l.loan_id,
l.loan_amount - ifnull(sum(p.amount_paid),0) as outstanding_amount
from loans l
left join payments p on l.loan_id=p.loan_id
group by  l.loan_amount,l.loan_id;

-- 4.Customers with delayed EMIs
select * from loans;
select * from customers;
select * from payments;

select distinct loan_id
from payments
where due_date < payment_date;


-- 5.No of defaulted loans()>30 days delay
select * from loans;
select * from customers;
select * from payments
select count(distinct loan_id) as defaulted_loans
from payments
where DATEDIFF(payment_date,due_date)>30;



-- 6.Top 3 customers by total loan amount
select * from loans;
select * from customers;
select * from payments

select customer_id,total_loan
from(
      select customer_id,
           sum(loan_amount) as total_loan,
           RANK() OVER (order by sum(loan_amount)DESC )as rnk
          from loans
           group by customer_id
	)t
where rnk<=3;
	
    
-- 6.Loans ending this month

select * from loans;
select * from customers;
select * from payments;

select loan_id,loan_end_date
from loans
where month(loan_end_date)=month(curdate())
   and year(loan_end_date)=year(curdate());
   
--- 7.Profit earned per loan

select * from loans;
select * from customers;
select * from payments;

select l.loan_id,
ifnull(sum(p.amount_paid),0) - l.loan_amount  as profit
from loans l
left join payments p on l.loan_id=p.loan_id
group by l.loan_id,l.loan_amount;


--- 9.Customers with no delays
select distinct customer_id
from loans
where loan_id NOT IN
(
select loan_id
from payments
where payment_date> due_date);


--- 10 lATEST loan per customer
select * from
          ( select loan_id,customer_id,loan_start_date,
           ROW_NUMBER() OVER ( PARTITION BY customer_id order by loan_start_date desc )AS rn
           from loans ) t
where rn=1;
