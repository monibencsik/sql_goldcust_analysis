with product_segments as (
select 
gold_dim_products.product_key,
gold_dim_products.product_name,
gold_dim_products."cost",
case when cost < 100 then 'below 100'
	 when cost between 100 and 500 then '100-500'
	 when cost between 500 and 1000 then '500-1000'
	 else 'above 1000'
end cost_range
from gold_dim_products)
select
cost_range,
COUNT(product_key) as total_products
from product_segments
group by cost_range 