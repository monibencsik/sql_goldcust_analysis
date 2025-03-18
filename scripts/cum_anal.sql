USE `DataWarehouseAnalytics`;
SELECT t.order_month, total_sales, SUM(total_sales) OVER (ORDER BY t.order_month) AS running_total_sales, AVG(t.avg_price) OVER (ORDER BY t.order_month) AS moving_average
FROM(
SELECT 
date_trunc('YEAR', order_date) AS order_year,
date_trunc('MONTH', order_date) AS order_month,
SUM(sales_amount) AS total_sales, 
AVG(gold_fact_sales.price ) as avg_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY date_trunc('YEAR', order_date), date_trunc('MONTH', order_date)
) t
;


