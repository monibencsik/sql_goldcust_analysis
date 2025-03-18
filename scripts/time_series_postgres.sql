USE DataWarehouseAnalytics;
SELECT 
date_part('YEAR', order_date) as order_year,
date_part('MONTH', order_date) as order_month, 
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_cust,
SUM(quantity) as total_quant 
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY date_part('YEAR', order_date), date_part('MONTH', order_date)
ORDER BY date_part('YEAR', order_date), date_part('MONTH', order_date);