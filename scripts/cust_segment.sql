with customer_spending as (
select
c.customer_key,
SUM(s.sales_amount) as total_spend,
MIN(s.order_date) as first_order,
MAX(s.order_date) as last_order,
EXTRACT(YEAR FROM AGE(MAX(s.order_date), MIN(s.order_date))) * 12 + 
    EXTRACT(MONTH FROM AGE(MAX(s.order_date), MIN(s.order_date))) AS m_lifespan
from
gold_fact_sales s
left join gold_dim_customers c
on c.customer_key  = s.customer_key
group by c.customer_key)
select 
customer_segment,
COUNT(t.customer_key) as total_customers
from (
	select
	customer_key,
	total_spend,
	m_lifespan,
	case when total_spend > 5000 and m_lifespan >= 12 then 'VIP'
	 	when total_spend <= 5000 and m_lifespan >= 12 then 'Regular'
	 	else 'new'
	end customer_segment
	from customer_spending) t 
group by customer_segment 
order by total_customers DESC