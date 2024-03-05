# Git Repository README

## Introduction
This repository contains SQL queries for performing data cleansing and exploration on the weekly sales dataset. The dataset includes information about sales transactions, such as date, region, platform, segment, customer type, transactions, and sales amount.

## Schema
The schema for the `weekly_sales` table is as follows:
- `week_date`: Date of the week
- `region`: Region where the sales occurred
- `platform`: Platform used for the sales
- `segment`: Segment of customers
- `customer_type`: Type of customer
- `transactions`: Number of transactions
- `sales`: Sales amount

## Data Cleansing
In the data cleansing step, a new table named `clean_weekly_sales` is created with additional columns:
1. `week_number`: Week number based on the `week_date`
2. `month_number`: Month number based on the `week_date`
3. `calendar_year`: Year based on the `week_date`
4. `age_band`: Age band derived from the `segment` column
5. `demographic`: Demographic group derived from the `segment` column
6. `avg_transaction`: Average transaction value calculated as the ratio of `sales` to `transactions`

## Data Exploration
Data exploration is performed using SQL queries to extract insights from the cleaned dataset. Various questions are answered, including:
1. Missing week numbers in the dataset
2. Total transactions for each year
3. Total sales for each region and month
4. Total transactions for each platform
5. Percentage of sales for Retail vs. Shopify for each month
6. Percentage of sales by demographic for each year
7. Age band and demographic values contributing most to Retail sales
8. Average transaction value for each month in each year
9. Variation of average transaction value by region and platform for each month
10. Trend of total sales over the years for each demographic
11. Age band contributing the most to sales on Shopify for each month
12. Customer type with the highest average transaction value for each month
13. Distribution of average transaction values across different age bands and demographics

## Conclusion
These SQL queries provide valuable insights into the weekly sales dataset, helping businesses make informed decisions and optimize their sales strategies.
