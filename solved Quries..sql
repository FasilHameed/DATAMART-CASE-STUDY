
-- default database
use case1;

-- Case Study Questions 

## Data Cleansing
-- Data Cleansing Steps
-- In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
-- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2, etc.
-- Add a month_number with the calendar month for each week_date value as the 3rd column
-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value


create table clean_weekly_sales 
as select week_date,
week(week_date) as week_number, 
month(week_date) as month_number, 
year(week_date) as calender_year, region, platform,
case 
when segment = null then 'Unkown'
else segment
end as segment,
case
     when right(segment,1)= '1' then 'Young Adults'
     when right(segment,1)= '2' then 'Middle Aged'
     when right(segment,1) in ('3','4') then 'Ritirees'
     else 'Unknown'
     end as 'age_band',
case
     when left(segment,1)= 'C' then 'Couples'
     when right(segment,1)= 'F' then 'Families'
	 else 'Unknown'
     end as 'demographic', 
     customer_type,transactions,sales,
     round(sales/transactions,2) as 'avg_transaction'
         
from weekly_sales;



select *from clean_weekly_sales limit 10;



-- Data Exploration



-- Question 1: Which week numbers are missing from the dataset?

create table seq100
(x int not null auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x + 50 from seq100;
select * from seq100;
create table seq52 as (select x from seq100 limit 52);
select distinct x as week_day from seq52 where x not in(select distinct week_number from clean_weekly_sales); 

select distinct week_number from clean_weekly_sales;





-- Questions 2 : How many total transactions were there for each year in the dataset?
select calender_year,
sum(transactions) as total_transactions 
from clean_weekly_sales 
group by calender_year;






-- Questions 3 : What are the total sales for each region for each month?

select region,month_number,sum(sales) as total_sales
from clean_weekly_sales group by month_number , region;






-- Question 4 : What is the total count of transactions for each platform

select platform,sum(transactions) as total_transactions from clean_weekly_sales  group by platform;





-- Question 5:  What is the percentage of sales for Retail vs Shopify for each month?

WITH cte_monthly_platform_sales AS (
  SELECT
    month_number,calendar_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY month_number,calendar_year, platform
)
SELECT
  month_number,calendar_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number,calendar_year
ORDER BY month_number,calendar_year;






## 6.What is the percentage of sales by demographic for each year in the dataset?

SELECT
  calendar_year,
  demographic,
  SUM(SALES) AS yearly_sales,
  ROUND(
    (
      100 * SUM(sales)/
        SUM(SUM(SALES)) OVER (PARTITION BY demographic)
    ),
    2
  ) AS percentage
FROM clean_weekly_sales
GROUP BY
  calendar_year,
  demographic
ORDER BY
  calendar_year,
  demographic;



  
## 7.Which age_band and demographic values contribute the most to Retail sales?

SELECT
  age_band,
  demographic,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;



-- Question 8: What is the average transaction value for each month in each year?

SELECT
  calendar_year,
  month_number,
  AVG(avg_transaction) AS avg_transaction_value
FROM clean_weekly_sales
GROUP BY
  calendar_year,
  month_number
ORDER BY
  calendar_year,
  month_number;





-- Question 9: How does the average transaction value vary by region and platform for each month?

SELECT
  month_number,
  region,
  platform,
  AVG(avg_transaction) AS avg_transaction_value
FROM clean_weekly_sales
GROUP BY
  month_number,
  region,
  platform
ORDER BY
  month_number,
  region,
  platform;





-- Question 10: What is the trend of total sales over the years for each demographic?

SELECT
  calendar_year,
  demographic,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY
  calendar_year,
  demographic
ORDER BY
  calendar_year,
  total_sales DESC;





-- Question 11: For each month, which age band contributes the most to sales on Shopify?

WITH cte_shopify_sales AS (
  SELECT
    month_number,
    age_band,
    SUM(sales) AS total_sales
  FROM clean_weekly_sales
  WHERE platform = 'Shopify'
  GROUP BY
    month_number,
    age_band
)
SELECT
  month_number,
  age_band,
  total_sales
FROM (
  SELECT
    month_number,
    age_band,
    total_sales,
    ROW_NUMBER() OVER (PARTITION BY month_number ORDER BY total_sales DESC) AS rn
  FROM cte_shopify_sales
) AS ranked_sales
WHERE rn = 1
ORDER BY
  month_number;





-- Question 12: Which customer type has the highest average transaction value for each month?

SELECT
  month_number,
  customer_type,
  AVG(avg_transaction) AS avg_transaction_value
FROM clean_weekly_sales
GROUP BY
  month_number,
  customer_type
ORDER BY
  month_number,
  avg_transaction_value DESC;

  

-- Question 13: What is the distribution of average transaction values across different age bands and demographics?

SELECT
  age_band,
  demographic,
  COUNT(*) AS count_transactions,
  MIN(avg_transaction) AS min_avg_transaction,
  MAX(avg_transaction) AS max_avg_transaction,
  ROUND(AVG(avg_transaction), 2) AS avg_avg_transaction
FROM clean_weekly_sales
GROUP BY
  age_band,
  demographic
ORDER BY
  count_transactions DESC;





     