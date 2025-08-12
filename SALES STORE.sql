DROP TABLE IF EXISTS sales_store;

CREATE TABLE sales_store(
transaction_id VARCHAR(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR (15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);
SELECT * INTO sales FROM sales_store;

SELECT * FROM sales_store;
SELECT * FROM sales;

--DATA CLEANING
---STEP 1:TO CHECK FOR DUPLICATE
SELECT  transaction_id,COUNT(*)
FROM sales
GROUP BY transaction_id
HAVING COUNT(transaction_id) > 1

"TXN855235"
"TXN240646"
"TXN342128"
"TXN981773"

WITH CTE AS(
SELECT *,
    ROW_NUMBER()OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
FROM sales	
)
--DELETE FROM sales
--USING CTE
--WHERE sales.ctid = CTE.ctid
-- AND CTE.row_num = 2
SELECT * FROM CTE
WHERE transaction_id IN ('TXN855235','TXN240646','TXN342128','TXN981773')

--STEP 2 CORRECTION OF HEADING
ALTER TABLE sales
RENAME  COLUMN quantiy TO quantity

ALTER TABLE sales
RENAME COLUMN prce TO price

--STEP 3 CHECK DATATYPES
SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='sales'

-- STEP 4 TO CHECK NULL


SELECT *
FROM sales
WHERE transaction_id ISNULL
OR customer_id IS NULL
OR customer_name IS NULL
OR customer_age	IS NULL
OR gender	IS NULL
OR product_id IS NULL
OR product_name	IS NULL
OR product_category	IS NULL
OR quantiTy IS NULL
OR price IS NULL
OR payment_mode	IS NULL
OR purchase_date IS NULL
OR time_of_purchase IS NULL
OR status IS NULL;

--TREATING NULL VALUES
DELETE FROM sales
WHERE transaction_id IS NULL;

SELECT * FROM sales 
WHERE customer_name='Ehsaan Ram'

UPDATE sales
SET customer_id='CUST9494'
WHERE transaction_id='TXN977900'

SELECT * FROM sales
WHERE customer_name='Damini Raju'

UPDATE sales
SET customer_id='CUST1401'
WHERE transaction_id='TXN985663'

SELECT * FROM sales
WHERE customer_id='CUST1003'

UPDATE sales
SET customer_name='Mahika Saini',customer_age=35,gender='Male'
WHERE transaction_id='TXN432798'

SELECT * FROM sales

--STEP 5 DATA CLEANING

SELECT  DISTINCT gender
FROM sales

UPDATE sales
SET gender='Male'
WHERE gender='M'

UPDATE sales
SET gender='Female'
WHERE gender='F'

SELECT DISTINCT payment_mode
FROM sales

UPDATE sales 
SET payment_mode='Credit Card'
WHERE payment_mode='CC'

--DATA ANALYSIS

--1.WHAT ARE THE TOP 5 MOST SELLING PRODUCTS BY QUANTITY?

SELECT DISTINCT status
FROM sales

SELECT  product_name, SUM(quantity) AS total_quantity_sold 
FROM sales
WHERE status='delivered'
GROUP BY product_name
ORDER BY total_quantity_sold desc
limit 5
-- BUISNESS PROBLEM:WE DON'T KNOW WHICH PRODUCTS ARE MOST IN DEMAND.
--BUISNESS IMPACT:HELPS PROITIZE STOCK AND BOOST SALES THROUGH TARGETED PROMOTIONS.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--2. WHICH PRODUCT IS MOST FREQUENTLY CANCELLED.
SELECT product_name,COUNT(*) AS total_cancelled
FROM sales
WHERE status='cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC
LIMIT 5
-- BUISNESS PROBLEM:FREQUEBT CANCELLATIONS AFFECT REVENUE AND CUSTOMER TRUST.
--BUISNESS IMPACT:IDENTIFY POOR-PERFORMING PRODUCT TO IMPROVE QUALITY OR REMOVE FROM CATLOG.

----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM sales

--3. WHAT TIME OF THE DAY HAS THE HIGHEST NUMBER OF PURCHASES?  

SELECT  time_of_day,
       COUNT(*) AS total_order
FROM (
    SELECT
     CASE 
	     WHEN EXTRACT (HOUR FROM time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		 WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		 WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		 WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	END AS time_of_day
FROM sales
) AS sub
GROUP BY time_of_day
ORDER BY total_order DESC
-- BUISNESS PROBLEM SOLVED:FIND PEAK SALES TIME.
--BUISNESS IMPACT :OPTIMIXING STAFFING, PROMOTIONS, AND SERVER LOADS.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--4. WHO ARE THE TOP HIGHEST SPENDING CUSTOMERS?

SELECT customer_name,
        TO_CHAR(SUM(price* quantity),'FM$9,99,999.00')AS total_spend
FROM sales
GROUP BY customer_name
ORDER BY SUM(price* quantity) DESC
LIMIT 5
--BUISNESS PROBLEM SOLVED : IDENTIFY VIP CUSTOMERS
--BUISNESS IMPACT :PERSONALIZED OFFERS,LOYALITY REWARDS AND RETANTION.
----------------------------------------------------------------------------------------------------------------------------------------------------------

--5. WHICH PRODUCT CATEGORIES GENERATE THE HIGHEST REVENUE?
SELECT product_category ,
        TO_CHAR(SUM(price* quantity),'FM$9,99,999,00') AS revenue
FROM sales
GROUP BY product_category
ORDER BY SUM(price* quantity) DESC
limit 5
--BUISNESS PROBLEM SOLVED:IDENTIFY TOP- PERFORMING PRODUCT CATEGORIES.
---BUISNESS IMPACT:REFINE PRODUCT STRATEGY, SUPPLY CHAIN AND PROMOTIONS.
--ALLOWING THE BUISNESS TO INVEST MORE IN HIGH-MARGIN OR HIGH -DEMAND CATEGORIES.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--6.WHAT IS THE RETURN CANCELLATION RATE PER PRODUCT CATEGORY?
SELECT* FROM sales

--CANCELLED
SELECT product_category,
 TO_CHAR(
 (COUNT (CASE WHEN status='cancelled' THEN 1 END)*100.0/COUNT(*)), 'FM99,990.00') || '%' AS cancelled_percent
FROM sales
GROUP BY product_category
ORDER BY cancelled_percent DESC


--RETURN
SELECT product_category,
TO_CHAR(
      (COUNT( CASE WHEN status='returned'THEN 1 END)*100.0/COUNT(*)),'FM99,990.00')||'%'AS returned_percent
FROM sales
GROUP BY product_category
ORDER BY return_percent DESC

--BUISNESS PROBLEM:MONITOR DISSATIFICATION TRENDS PER CATEGORY.
--BUISNESS IMPACT:REDUCE RETURNS,IMPROVE PRODUCT DESCIPTION/EXPECTATION.
--HELPS IDENTIFY AND FIX PRODUCT OR LOGISTICS ISSUES.

----------------------------------------------------------------------------------------------------------------------------------------------------------
--7.WHAT IS THE MOST PREFFERED PAYMENT MODE.
SELECT * FROM sales

SELECT payment_mode,
        COUNT(payment_mode) AS total_count
FROM sales		
GROUP BY payment_mode
ORDER BY total_count DESC
--BUSINESS PROBLEM :KNOW WHICH PAYMENT OPTIONS CUSTOMERS PREFERS
--BUISNESS IMPACT:STREAMLINE PAYMENT PROCESSING,PRORITIZE POPULAR MODES.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--8.HOW DOES AGE GROUP AFFECT PURCHASING BEHAVIOUR?
SELECT * FROM sales
SELECT MIN(customer_age) ,MAX(customer_age)
FROM sales

SELECT 
    CASE 
	   WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
	   WHEN customer_age BETWEEN 26 AND 40 THEN '26-35'
	   WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
	   ELSE '51+'
	END  AS group_age,
   TO_CHAR(SUM(price* quantity),'FM$99,999,000')AS total_purchase
FROM sales
GROUP BY group_age
ORDER BY SUM(price* quantity) DESC

--BUISNESS PROBLEM :UNDERSTAND CUSTOMER DEMOGRAPHICS.
--BUISNESS IMPACT :TARGETED MARKETING AND PRODUCT RECOMMENDATION BY GROUP AGE.
----------------------------------------------------------------------------------------------------------------------------------------------------------
--9.WHAT IS THE MONTHLY SALES TRENDS?

SELECT * FROM sales

--METHOD 1
SELECT 
   TO_CHAR(purchase_date,'YYYY-MM') AS month_year,
   TO_CHAR(SUM(price*quantity),'FM$99,99,000') AS total_sales,
   SUM(quantity) AS total_quantity
FROM sales
GROUP BY TO_CHAR(purchase_date,'YYYY-MM')
ORDER BY month_year ASC

--METHOD 2

SELECT
     --EXTRACT (YEAR FROM purchase_date) AS years,
	  EXTRACT (MONTH  FROM purchase_date) AS months,
	  TO_CHAR(SUM(price* quantity),'FM$99,99,000')AS total_sales,
	  sum(quantity) AS total_quantity
FROM sales
GROUP BY --EXTRACT (YEAR FROM purchase_date) ,
	  EXTRACT (MONTH  FROM purchase_date)
ORDER BY months ASC	  
--BUISNESS PROBLEM: SALE FLACTUATIONS GO UNNOTICED
--BUISNESS IMPACT:PLAN INVENTORY AND MARKETING ACCORDING TO SEASONAL TRENDS.

----------------------------------------------------------------------------------------------------------------------------------------------------------
--10.ARE CERTAIN GENDERS BUYING MORE SPECIFIC PRODUCT CATEGORIES?
SELECT * FROM sales
--METHOD  1 
SELECT gender,product_category,
       COUNT(product_category)AS total_purchase
FROM sales
GROUP BY gender,product_category
ORDER BY gender 
 --METHOD 2
 CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
    $$
    SELECT product_category, gender, COUNT(*)
    FROM sales
    GROUP BY product_category, gender
    ORDER BY product_category, gender
    $$,
    $$ VALUES ('Male'), ('Female') $$
) AS ct (
    product_category text,
    male int,
    female int
);

--BUISNESS PROBLEM :GENDER-BASED PRODUCT PREFERENCES
--BUISNESS IMPACT:PERSONALIZED ADS,GENDER-FOCUSED CAMPAIGNS.









