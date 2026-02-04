-- DAY 10

/*  
Purpose:
- Transform raw loan data into analytics-ready curated table
- Apply business logic, flags, and categories
- This script is intended to run as a scheduled job
*/

show databases;
show tables from loananalyticsdb;
use loananalyticsdb;
describe loan_raw;
drop table loan_curated;

create table loan_curated as
	select 
		loan_id,
		customer_id,
		loan_amount,
		interest_rate,
		tenure_months,
		loan_status,
		emi_amount,
		disbursement_date,
		last_payment_date,
		outstanding_amount,
		created_date ,
        
-- Business Flag
        case when loan_status ='Default' then 1 else 0 end as is_default_loan,
		case when loan_status ='Active' then 1 else 0 end as is_active_loan,
          
-- Risk Categorization
        case
        when outstanding_amount > 500000 then 'High-Risk'
        when outstanding_amount between 200000 and 500000 then 'Medium-Risk'
        else 'Low-Risk'
        end as risk_category,
        
-- Loan_Tenure category
        case 
		when tenure_months <=24 then 'Short-Term'
        when tenure_months between 25 and 60 then 'Medium-Term'
        else'Long-Term'
        end as loan_term_category,
         
-- Portfolio segment
       case
       when loan_status ='Default' and outstanding_amount > 300000 then 'Critical'
       when loan_status ='Active' and outstanding_amount> 300000 then 'Watchlist'
       else 'Normal'
       end as portfolio_segment
        
from loan_raw;

select count(*) as total_count from loan_curated;

select loan_id,loan_amount from loan_curated;
select sum(loan_amount) as total_loan_amount from loan_curated;


-- Job Schedule (Assumption):
-- Frequency: Daily
-- Load Type: Full refresh (can be optimized to incremental)
-- Downstream Consumers: Power BI, Databricks SQL
