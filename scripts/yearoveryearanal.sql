with yearly_product_sales AS(
select 
DATE_PART('YEAR', f.order_date) as order_year,
p.product_name,
SUM(f.sales_amount) as current_sales
from gold_fact_sales f
left join gold_dim_products p
on f.product_key = p.product_key 
where order_date is not NULL
group by order_year, p.product_name
)
select 
order_year,
product_name,
current_sales,
AVG(current_sales) over (partition by product_name) avg_sales,
current_sales - AVG(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - AVG(current_sales) over (partition by product_name) > 0 then 'Above avg'
	when current_sales - AVG(current_sales) over (partition by product_name) < 0 then 'Below avg'
	else 'avg'
end avg_change,
lag(current_sales) over (partition by product_name order by order_year) py_sales,
current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
	when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
	else 'No change'
end py_change
from yearly_product_sales 
ORDER by product_name, order_year   