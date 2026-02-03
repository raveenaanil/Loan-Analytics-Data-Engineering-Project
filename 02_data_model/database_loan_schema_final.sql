-- DAY 9


use loananalyticsdb;

-- Data ingestion
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/loan_raw_data.csv'
  into TABLE loan_raw
  fields terminated by ','
  enclosed by '"'
  lines terminated by '\n'
  ignore 1 rows;
  
show variables like 'secure_file_priv';
   
   
-- Raw Loan Data Table (source system extract)
create table loan_raw (
  loan_id VARCHAR (50),
  customer_id VARCHAR(50),
  loan_amount DECIMAL(12,2),
  interest_rate DECIMAL (5,2),
  tenure_months INT ,
  loan_status VARCHAR (20),
  emi_amount DECIMAL (10,2),
  disbursement_date DATE,
  last_payment_date DATE,
  outstanding_amount DECIMAL(12,2),
  created_date date
  );


--- Steps  
--- 1.Create columns	CREATE TABLE
--- 2.Convert dates	LOAD DATA ... SET
--- 3.Client file	LOCAL INFILE
--- 4.Server file	INFILE
--- 5. CSV ≠ DATE format	STR_TO_DATE()


  -- Raw Loan Data Table (source system extract)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/loan_raw_data.csv'
  into TABLE loan_raw
  fields terminated by ','
  enclosed by'"'
  lines terminated by "\n"
  ignore 1 rows
  (
  loan_id,
  customer_id ,
  loan_amount ,
  interest_rate ,
  tenure_months  ,
  loan_status ,
  emi_amount ,
  @disbursement_date,
  @last_payment_date ,
  outstanding_amount ,
 @created_date 
  )
  set disbursement_date =str_to_date(@disbursement_date,'%d-%m-%Y'),
      last_payment_date =str_to_date(@last_payment_date,'%d-%m-%Y'),
      created_date =str_to_date(@created_date,'%d-%m-%Y');
  
SELECT loan_id, disbursement_date, last_payment_date, created_date
FROM loan_raw
LIMIT 5;
