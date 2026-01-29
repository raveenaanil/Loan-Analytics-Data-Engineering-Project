---- DAY 8: BUSINESS LOGIC DERIVED COLUMNS FOR LOAN ANALYTICS
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
(107,6,48,800000,'Default','2024-03-04','2028-03-04'),
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
(9,107,'2024-05-04','2024-05-03',13000),
(10,107,'2024-06-04','2024-08-13',13000)
;

SELECT * FROM customers;
SELECT * FROM loans;
SELECT * FROM payments;

-- 1.Active flag
select * ,
case when loan_status='Active' then 1
     else 0
end as is_active_flag
from loans;


-- 2.Default flag
select * ,
case when loan_status='Active' then 1
     else 0
end as is_active_flag
from loans; 

-- 3.Outstanding amount
select l.loan_id,
(l.loan_amount -ifnull(sum(p.amount_paid),0)) as outstanding_amount
from loans l
left join payments p on l.loan_id=p.loan_id
group by l.loan_id,l.loan_amount;


-- 4. Loan risk category based on outstanding amount
select l.loan_id,
(l.loan_amount -ifnull(sum(p.amount_paid),0)) as outstanding_amount,
case when (l.loan_amount -ifnull(sum(p.amount_paid),0)) < 200000 then 'low-risk'
     when (l.loan_amount -ifnull(sum(p.amount_paid),0)) between 200000 and 400000 then 'medium-risk'
     when (l.loan_amount -ifnull(sum(p.amount_paid),0)) > 400000 then 'high-risk'
     end as risk_category
from loans l
left join payments p on l.loan_id=p.loan_id
group by l.loan_id, l.loan_amount;

-- 5.Loan term category
  select l.loan_id,l.tenure_months,
    case when l.tenure_months <= 24 then 'short-term'
     when l.tenure_months between 24 and 36 then 'medium-term'
     when l.tenure_months > 36 then 'long-term'
     end as loan_term_category
      from loans l;

-- 6.combining query
select l.loan_id,l.tenure_months,
(l.loan_amount -ifnull(sum(p.amount_paid),0)) as outstanding_amount,
case when (l.loan_amount -ifnull(sum(p.amount_paid),0)) < 200000 then 'low-risk'
     when (l.loan_amount -ifnull(sum(p.amount_paid),0)) between 200000 and 400000 then 'medium-risk'
     when (l.loan_amount -ifnull(sum(p.amount_paid),0)) > 400000 then 'high-risk'
     end as risk_category,
case when l.tenure_months <= 24 then 'short-term'
     when l.tenure_months between 24 and 36 then 'medium-term'
     when l.tenure_months > 36 then 'long-term'
     end as loan_term_category
from loans l 
left join payments p on l.loan_id=p.loan_id
 group by l.loan_id,l.loan_amount,l.tenure_months;


-- clean version
SELECT
    l.loan_id,
    l.tenure_months,
    l.loan_status,
    l.loan_amount - IFNULL(p.total_paid, 0) AS outstanding_amount,

    CASE
        WHEN l.loan_amount - IFNULL(p.total_paid, 0) < 200000 THEN 'low-risk'
        WHEN l.loan_amount - IFNULL(p.total_paid, 0) BETWEEN 200000 AND 400000 THEN 'medium-risk'
        ELSE 'high-risk'
    END AS risk_category,

    CASE
        WHEN l.tenure_months <= 24 THEN 'short-term'
        WHEN l.tenure_months BETWEEN 25 AND 36 THEN 'medium-term'
        ELSE 'long-term'
    END AS loan_term_category

FROM loans l
LEFT JOIN (
    SELECT loan_id, SUM(amount_paid) AS total_paid
    FROM payments
    GROUP BY loan_id
) p
ON l.loan_id = p.loan_id;


--- 7 which loan need immediate attention?
SELECT
    l.loan_id,
    l.tenure_months,
    l.loan_status,
    l.loan_amount - IFNULL(p.total_paid, 0) AS outstanding_amount,

    CASE
        WHEN l.loan_amount - IFNULL(p.total_paid, 0) < 200000 THEN 'low-risk'
        WHEN l.loan_amount - IFNULL(p.total_paid, 0) BETWEEN 200000 AND 400000 THEN 'medium-risk'
        ELSE 'high-risk'
    END AS risk_category,

    CASE
        WHEN l.tenure_months <= 24 THEN 'short-term'
        WHEN l.tenure_months BETWEEN 25 AND 36 THEN 'medium-term'
        ELSE 'long-term'
    END AS loan_term_category,

    CASE
       WHEN loan_status='Default' AND l.loan_amount - IFNULL(p.total_paid, 0)>300000 then 'critical'
	 WHEN loan_status='Active' AND l.loan_amount - IFNULL(p.total_paid, 0)>300000 then 'watchlist'
     else 'Normal'
     end as potfolio_segment
FROM loans l
LEFT JOIN (
    SELECT loan_id, SUM(amount_paid) AS total_paid
    FROM payments
    GROUP BY loan_id
) p
ON l.loan_id = p.loan_id;
