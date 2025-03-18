with category_sales as (
select 
category,
SUM(sales_amount) as total_sales
from gold_fact_sales f
left join gold_dim_products p
on p.product_key  = f.product_key 
group by category)
select 
category,
total_sales, 
SUM(total_sales) over() overall_sales,
ROUND((total_sales / SUM(total_sales) over() ) * 100,2) as perc_sales
from category_sales 