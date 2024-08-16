-- Q1: Create table to track total successful orders per day
CREATE TABLE foodpanda-assessment-415715.Foodpanda_own_food_brands.Successful_Orders_Per_Day AS
SELECT date_local, COUNT(*) AS total_successful_orders 
FROM `foodpanda-assessment-415715.Foodpanda_own_food_brands.orders`
WHERE is_successful_order = TRUE
GROUP BY date_local;

-- Q2: Create table to track number of customers who have placed at least one successful order
CREATE TABLE Foodpanda_own_food_brands.Customers_With_At_Least_One_Order AS
SELECT COUNT(DISTINCT customer_id) AS total_customers_with_successful_orders
FROM `foodpanda-assessment-415715.Foodpanda_own_food_brands.orders`
WHERE is_successful_order = TRUE;

-- Q3: Create table to track successful orders per restaurant per day
CREATE TABLE Foodpanda_own_food_brands.Successful_Orders_Per_Restaurant_Per_Day AS
SELECT 
    o.date_local,
    v.vendor_name,
    COUNT(*) AS total_successful_orders
FROM `foodpanda-assessment-415715.Foodpanda_own_food_brands.orders` AS o
JOIN (
    SELECT id, vendor_name
    FROM `foodpanda-assessment-415715.Foodpanda_own_food_brands.vendors`
) AS v
ON o.vendor_id = v.id
WHERE o.is_successful_order = TRUE
GROUP BY o.date_local, v.vendor_name;

-- Q4: Create table to track average products per order per day
CREATE TABLE Foodpanda_own_food_brands.Average_Products_Per_Order_Per_Day AS
SELECT 
    date_local,
    AVG(products_count_per_order) AS avg_products_per_order_per_day
FROM (
    SELECT 
        date_local,
        (LENGTH(product_id) - LENGTH(REPLACE(product_id, ',', '')) + 1) AS products_count_per_order
    FROM Foodpanda_own_food_brands.orders
    WHERE is_successful_order = TRUE
) AS subquery
GROUP BY date_local;

-- Q5: Create table to track number of customers who have reordered at least once between 9th October 2012 and 15th October 2012
CREATE TABLE Foodpanda_own_food_brands.Customers_With_Reorders_Last_7_Days AS
SELECT COUNT(DISTINCT customer_id) AS total_customers_with_reorders_last_7_days
FROM (
    SELECT customer_id
    FROM `foodpanda-assessment-415715.Foodpanda_own_food_brands.orders`
    WHERE is_successful_order = TRUE
    AND date_local BETWEEN '2012-10-09' AND '2012-10-15'
    GROUP BY customer_id
    HAVING COUNT(is_successful_order) > 1
) AS subquery;
