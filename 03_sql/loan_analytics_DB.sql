USE loananalyticsdb;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE customers;
DROP TABLE loans;
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
(3,'Suresh Rao','suresh@gmail.com','Hyderabad','2023-03-15');

INSERT INTO loans VALUES
(101,1,500000,'Active','2023-02-01','2026-02-01'),
(102,2,300000,'Closed','2022-01-01','2024-01-01'),
(103,3,700000,'Active','2023-05-01','2027-05-01');

INSERT INTO payments VALUES
(1,101,'2023-03-01',20000),
(2,101,'2023-04-01',20000),
(3,102,'2022-02-01',25000);

select * from customers;
select * from loans;
select * from payments;

select customer_name,sum(loan_amount) as total_loan
from customers c
join loans l on c.customer_id=l.customer_id
group by c.customer_name;

select loan_status, count(*) as loan_count
from loans
group by loan_status;

select loan_id,sum(amount_paid) as total_paid
from payments
group by loan_id;

select l.loan_id, 
	   l.loan_amount-ifnull(sum(p.amount_paid),0) as outstanding_amount
from loans l
left join payments p on l.loan_id=p.loan_id
group by l.loan_id,l.loan_amount;

select *
from loans
where loan_status='Active';






